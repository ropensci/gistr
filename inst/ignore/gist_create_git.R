#' Create a gist via git instead of the GitHub Gists HTTP API
#'
#' @export
#' @template args
#' @param artifacts (logical/character) Include artifacts or not. If \code{TRUE}, 
#' includes all artifacts. Or you can pass in a file extension to only upload 
#' artifacts of certain file exensions. Default: \code{FALSE}
#' @param git_method (character) One of ssh (default) or https. If a remote already
#' exists, we use that remote, and this parameter is ignored. 
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
#' this function can easily collect all artifacts coming out of a knit process.
#' @seealso \code{\link{gist_create}}, \code{\link{gist_create_obj}}
#' @examples \dontrun{
#' # prepare a directory and a file
#' dir.create("~/gitgist")
#' file <- system.file("examples", "stuff.md", package = "gistr")
#' writeLines(readLines(file), con = "~/gitgist/stuff.md")
#' 
#' # create a gist
#' gist_create_git(files = "~/gitgist/stuff.md")
#' gist_create_git(files = c("~/gitgist/stuff.md", "~/gitgist/icanhazallthedata.md"))
#' gist_create_git(files = "~/gitgist")
#' 
#' # binary files
#' gist_create_git(files = "~/gitgist/ropensci_add.png")
#' 
#' # knit files first, then push up
#' gist_create_git(files = "~/gitgistknit/plots.Rmd", knit = TRUE)
#' 
#' # collect all/any artifacts from knitting process
#' gist_create_git("~/gitgistartifacts/artifacts_eg1.Rmd", knit = TRUE, 
#'    artifacts = TRUE)
#' 
#' # from code
#' gist_create_git(code={'
#' x <- letters
#' numbers <- runif(8)
#' numbers
#'
#' [1] 0.3229318 0.5933054 0.7778408 0.3898947 0.1309717 0.7501378 0.3206379 0.3379005
#' '}, filename="my_cool_code.R")
#' 
#' # include artifacts, e.g., images created during knit process
#' file <- system.file("examples", "plots.Rmd", package = "gistr")
#' dir <- tempdir()
#' file.copy(file, dir)
#' file <- file.path(dir, "plots.Rmd")
#' setwd(dir)
#' gist_create_git(file)
#' gist_create_git(file, knit = TRUE)
#' gist_create_git(file, knit = TRUE, artifacts = TRUE)
#' }

gist_create_git <- function(files = NULL, description = "", public = TRUE, browse = TRUE,
  knit = FALSE, code = NULL, filename = "code.R",
  knitopts=list(), renderopts=list(), include_source = FALSE, 
  artifacts = FALSE, imgur_inject = FALSE, git_method = "ssh", ...) {
  
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
    allfiles <- unlist(allfiles)
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
  if (git_method == "ssh") {
    git2r::push(git, "gistr", "refs/heads/master", force = TRUE)
  } else {
    cred <- git2r::cred_env("GITHUB_USERNAME", "GITHUB_PAT")
    git2r::push(git, "gistr", "refs/heads/master", force = TRUE, credentials = cred)
  }
  # refresh gist metadata
  gst <- gist(gst$id)
  message("The file list for your gist may not be accurate if you are uploading a lot of files")
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
