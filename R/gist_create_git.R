#' Create a gist via git instead of the HTTP API
#'
#' @export
#' @import git2r
#'
#' @param files Files to upload, must be in the same directory.
#' @param description (character) Brief description of gist (optional)
#' @param public (logical) Whether gist is public (default: TRUE)
#' @param browse (logical) To open newly create gist in default browser (default: TRUE)
#' @param ... Further args passed on to \code{link[httr]{POST}}
#' @examples \dontrun{
#' gist_create_git(files = "~/gitgist/stuff.md")
#' gist_create_git(files = c("~/gitgist/stuff.md", "~/gitgist/icanhazallthedata.md"))
#' }

gist_create_git <- function(files, description = "", public = TRUE, browse = TRUE) {
  
  stopifnot(all(file.exists(files)))
  stopifnot(length(unique(dirname(files))) == 1)
  git <- git2r::init(dirname(files[[1]]))
  
  if (knit) {
    allfiles <- list()
    for (i in seq_along(files)) {
      ff <- files[[i]]
      dirpath <- dirname(ff)
      orig_files <- ff
      ff <- knit_render(ff, knitopts, renderopts)
      if (artifacts) {
        file_artifacts <- get_artifacts(ff, dirpath)
        files <- c(ff, file_artifacts)
      }
      if (include_source) ff <- c(orig_files, ff)
      allfiles[[i]] <- ff
    }
  } else {
    allfiles <- path.expand(files)
  }
  
  # add files
  git2r::add(git, basename(allfiles))
  # commit files
  git2r::commit(git, message = "added files from gistr")
  # create gist
  gst <- cgist(description, public)
  # add remote
  git2r::remote_add(git, "gistr", sprintf("git@gist.github.com:/%s.git", gst$id))
  # push up files
  git2r::push(git, "gistr", "refs/heads/master")
  # browse
  if (browse) browse(gist)
  return( gist )
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
