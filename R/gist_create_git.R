#' Create a gist via git instead of the GitHub Gists HTTP API
#'
#' @export
#' 
#' @template args
#' @param artifacts (logical/character) Include artifacts or not. If \code{TRUE}, 
#' includes all artifacts. Or you can pass in a file extension to only upload 
#' artifacts of certain file exensions. Default: \code{FALSE}
#' @param git_method (character) One of ssh (default) or https. If a remote already
#' exists, we use that remote, and this parameter is ignored. 
#' @param sleep (integer) Seconds to sleep after creating gist, but before 
#' collecting metadata on the gist. If uploading a lot of stuff, you may want to
#' set this to a higher value, otherwise, you may not get accurate metadata for
#' your gist. You can of course always refresh afterwards by calling \code{gist}
#' with your gist id.
#' 
#' @details Note that when \code{browse=TRUE} there is a slight delay in when 
#' we open up the gist in your default browser and when the data will display 
#' in the gist. We could have this function sleep a while and guess when it 
#' will be ready, but instead we open your gist right after we're done sending
#' the data to GitHub. Make sure to refresh the page if you don't see your 
#' content right away.
#' 
#' Likewise, the object that is returned from this function call may not have 
#' the updated and correct file information. You can retrieve that easily by 
#' calling \code{\link{gist}} with the gist id. 
#' 
#' This function uses git instead of the HTTP API, and thus requires
#' the R package \code{git2r}. If you don't have \code{git2r} installed, and 
#' try to use this function, it will stop and tell you to install \code{git2r}.
#' 
#' This function using git is better suited than \code{\link{gist_create}}
#' for use cases involving:
#' 
#' \itemize{
#'  \item Big files - The GitHub API allows only files of up to 1 MB in size. Using
#'  git we can get around that limit.
#'  \item Binary files - Often artifacts created are binary files like \code{.png}.
#'  The GitHub API doesn't allow transport of binary files, but we can do that with
#'  git. 
#' }
#' 
#' Another difference between this function and \code{\link{gist_create}} is that
#' this function can collect all artifacts coming out of a knit process.
#' 
#' If a gist is somehow deleted, or the remote changes, when you try to push to the
#' same gist again, everything should be fine. We now use \code{tryCatch} on the 
#' push attempt, and if it fails, we'll add a new remote (which means a new gist), 
#' and push again.
#' 
#' @seealso \code{\link{gist_create}}, \code{\link{gist_create_obj}}
#' 
#' @examples \dontrun{
#' # prepare a directory and a file
#' unlink("~/gitgist", recursive = TRUE)
#' dir.create("~/gitgist")
#' file <- system.file("examples", "stuff.md", package = "gistr")
#' writeLines(readLines(file), con = "~/gitgist/stuff.md")
#' 
#' # create a gist
#' gist_create_git(files = "~/gitgist/stuff.md")
#' 
#' ## more than one file can be passed in
#' unlink("~/gitgist2", recursive = TRUE)
#' dir.create("~/gitgist2")
#' file.copy(file, "~/gitgist2/")
#' cat("hello world", file = "~/gitgist2/hello_world.md")
#' list.files("~/gitgist2")
#' gist_create_git(c("~/gitgist2/stuff.md", "~/gitgist2/hello_world.md"))
#' 
#' # Include all files in a directory
#' unlink("~/gitgist3", recursive = TRUE)
#' dir.create("~/gitgist3")
#' cat("foo bar", file="~/gitgist3/foobar.txt")
#' cat("hello", file="~/gitgist3/hello.txt")
#' list.files("~/gitgist3")
#' gist_create_git("~/gitgist3")
#' 
#' # binary files
#' png <- system.file("examples", "file.png", package = "gistr")
#' unlink("~/gitgist4", recursive = TRUE)
#' dir.create("~/gitgist4")
#' file.copy(png, "~/gitgist4/")
#' list.files("~/gitgist4")
#' gist_create_git(files = "~/gitgist4/file.png")
#' 
#' # knit files first, then push up
#' # note: by default we don't upload images, but you can do that, see next example
#' rmd <- system.file("examples", "plots.Rmd", package = "gistr")
#' unlink("~/gitgist5", recursive = TRUE)
#' dir.create("~/gitgist5")
#' file.copy(rmd, "~/gitgist5/")
#' list.files("~/gitgist5")
#' gist_create_git("~/gitgist5/plots.Rmd", knit = TRUE)
#' 
#' # collect all/any artifacts from knitting process
#' arts <- system.file("examples", "artifacts_eg1.Rmd", package = "gistr")
#' unlink("~/gitgist6", recursive = TRUE)
#' dir.create("~/gitgist6")
#' file.copy(arts, "~/gitgist6/")
#' list.files("~/gitgist6")
#' gist_create_git("~/gitgist6/artifacts_eg1.Rmd", knit = TRUE, 
#'    artifacts = TRUE)
#' 
#' # from a code block
#' gist_create_git(code={'
#' x <- letters
#' numbers <- runif(8)
#' numbers
#'
#' [1] 0.3229318 0.5933054 0.7778408 0.3898947 0.1309717 0.7501378 0.3206379 0.3379005
#' '}, filename="my_cool_code.R")
#' 
#' # Use https instead of ssh
#' png <- system.file("examples", "file.png", package = "gistr")
#' unlink("~/gitgist7", recursive = TRUE)
#' dir.create("~/gitgist7")
#' file.copy(png, "~/gitgist7/")
#' list.files("~/gitgist7")
#' gist_create_git(files = "~/gitgist7/file.png", git_method = "https")
#' }

gist_create_git <- function(files = NULL, description = "", public = TRUE, browse = TRUE,
  knit = FALSE, code = NULL, filename = "code.R",
  knitopts=list(), renderopts=list(), include_source = FALSE, 
  artifacts = FALSE, imgur_inject = FALSE, git_method = "ssh", 
  sleep = 1, ...) {
  
  if (!requireNamespace("git2r", quietly = TRUE)) {
    stop("Please install git2r", call. = FALSE)
  }
  
  # pick git remote method
  git_method <- match.arg(git_method, c("ssh", "https"))
  
  # code handler
  if (!is.null(code)) files <- code_handler(code, filename)
  
  files <- makefiles(files)
  stopifnot(all(file.exists(files)))
  stopifnot(length(unique(dirname(files))) == 1)
  git <- git2r::init(dirname(files[[1]]))
  
  # knit if TRUE
  if (knit) {
    allfiles <- list()
    for (i in seq_along(files)) {
      ff <- files[[i]]
      dirpath <- dirname(ff)
      orig_files <- ff
      if (!is.null(code)) {
        ff <- tempfile(fileext = ".Rmd")
        writeLines(code, ff)
      }
      inject_imgur(ff, imgur_inject)
      ff <- knit_render(ff, knitopts, renderopts)
      if (artifacts) {
        file_artifacts <- all_artifacts(ff)
        ff <- c(ff, file_artifacts)
      }
      if (include_source) ff <- c(orig_files, ff)
      allfiles[[i]] <- ff
    }
    allfiles <- path.expand(unlist(allfiles))
  } else {
    allfiles <- path.expand(files)
  }
  
  # add files
  ftoadd <- gsub(sprintf("%s/?|\\./", git@path), "", allfiles)
  git2r::add(git, ftoadd)
  # commit files
  cm <- tryCatch(git2r::commit(git, message = "added files from gistr"), error = function(e) e)
  if (is(cm, "error")) message(strsplit(cm$message, ":")[[1]][[2]])
  # create gist
  gst <- as.gist(cgist(description, public))
  # add remote
  if (git_method == "ssh") {
    url <- sprintf("git@gist.github.com:/%s.git", gst$id)
  } else {
    url <- sprintf("https://gist.github.com/%s.git", gst$id)
  }
  ra <- tryCatch(git2r::remote_add(git, "gistr", url), error = function(e) e)
  if (is(ra, "error")) message(strsplit(ra$message, ":")[[1]][[2]])
  # push up files
  push_msg <- "Old remote not found on GitHub Gists\nAdding new remote\nRe-attempting push"
  if (git_method == "ssh") {
    trypush <- tryCatch(git2r::push(git, "gistr", "refs/heads/master", force = TRUE), 
                        error = function(e) e)
    if (is(trypush, "error")) {
      message(push_msg)
      git2r::remote_remove(git, "gistr")
      git2r::remote_add(git, "gistr", url)
      git2r::push(git, "gistr", "refs/heads/master", force = TRUE)
    }
  } else {
    cred <- git2r::cred_env("GITHUB_USERNAME", "GITHUB_PAT")
    trypush <- tryCatch(git2r::push(git, "gistr", "refs/heads/master", force = TRUE, credentials = cred),
                        error = function(e) e)
    if (is(trypush, "error")) {
      message(push_msg)
      git2r::remote_remove(git, "gistr")
      git2r::remote_add(git, "gistr", url)
      git2r::push(git, "gistr", "refs/heads/master", force = TRUE, credentials = cred)
    }
  }
  
  # wait a bit before collecting metadata
  Sys.sleep(sleep)
  
  # refresh gist metadata
  gst <- gist(gst$id)
  message("The file list for your gist may not be accurate if you are uploading a lot of files")
  message("Refresh the gist page if your files aren't there")
  
  # cleanup any temporary directories
  # unlink(dirname(allfiles[[1]]), recursive = TRUE, force = TRUE)
  
  # browse
  if (browse) browse(gst)
  return( gst )
}

makefiles <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    if (length(x) > 1) {
      unname(sapply(x, unpack))
    } else {
      unpack(x)
    }
  }
}

unpack <- function(z) {
  if (!file.exists(z)) stop(sprintf("'%s' does not exist", z), call. = FALSE)
  if (file.info(z)$isdir) {
    list.files(z, full.names = TRUE)
  } else {
    z
  }
}

cgist <- function(description, public) {
  res <- httr::POST(paste0(ghbase(), '/gists'), 
                    gist_auth(), 
                    encode = "json",
                    body = jsonlite::toJSON(list(
                      description = description,
                      public = public,
                      files = list(
                        ".gistr" = list(
                          content = "gistr"
                        )
                      )
                    ), auto_unbox = TRUE)
  )
  jsonlite::fromJSON(httr::content(res, "text"), FALSE)
}

all_artifacts <- function(x) {
  tmp <- list.files(dirname(x), full.names = TRUE, recursive = TRUE)
  tmp[ !tmp %in% path.expand(c(x, sub("\\.md", ".Rmd", x))) ]
}
