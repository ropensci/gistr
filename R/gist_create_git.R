#' Create a gist via git instead of the GitHub Gists HTTP API
#'
#' @export
#' @template args
#' @details This function uses git instead of the HTTP API, and thus requires
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
#' }

gist_create_git <- function(files = NULL, description = "", public = TRUE, browse = TRUE,
  knit = FALSE, code = NULL, filename = "code.R",
  knitopts=list(), renderopts=list(), include_source = FALSE, 
  artifacts = FALSE, imgur_inject = FALSE, ...) {
  
  if (!requireNamespace("git2r", quietly = TRUE)) {
    stop("Please install git2r", call. = FALSE)
  }
  
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
  git2r::add(git, basename(allfiles))
  # commit files
  git2r::commit(git, message = "added files from gistr")
  # create gist
  gst <- cgist(description, public)
  gst <- as.gist(gst)
  # add remote
  git2r::remote_add(git, "gistr", sprintf("git@gist.github.com:/%s.git", gst$id))
  # push up files
  git2r::push(git, "gistr", "refs/heads/master", force = TRUE)
  # .Call(git2r:::git2r_push, git, "gistr", "+refs/heads/master:refs/heads/master", NULL)
  # browse
  if (browse) browse(gst)
  return( gst )
}

makefiles <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    if (file.info(x)$isdir) {
      list.files(x, full.names = TRUE)
    } else {
      x
    }
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
  tmp <- list.files(dirname(x), full.names = TRUE)
  tmp[ !tmp %in% path.expand(c(x, sub("\\.md", ".Rmd", x))) ]
}
