#' Update/modify a gist
#'
#' @export
#' @param gist A gist object or something coerceable to a gist
#' @param description (character) Brief description of gist (optional)
#' @template all
#' @examples \dontrun{
#' file1 <- system.file("examples", "alm.md", package = "gistr")
#' file2 <- system.file("examples", "zoo.json", package = "gistr")
#' 
#' # add new files
#' gists(what = "minepublic")[[3]] %>%
#'  add_files(file1, file2) %>%
#'  update(config = verbose())
#'
#' # update existing files
#' ### file name has to match to current name
#' gists(what = "minepublic")[[3]] %>%
#'  update_files(file1) %>%
#'  update()
#'
#' # delete existing files
#' ### again, file name has to match to current name
#' gists(what = "minepublic")[[3]] %>%
#'  delete_files(file1, file2) %>%
#'  update()
#'
#' # rename existing files
#' # For some reason, this operation has to upload the content too
#' ### first name is old file name with path (must match), and second is new file name (w/o path)
#' ## add first
#' gists(what = "minepublic")[[3]] %>%
#'  add_files(file1, file2) %>%
#'  update()
#' ## then rename
#' gists(what = "minepublic")[[3]] %>%
#'  rename_files(list(file1, "newfile.md")) %>%
#'  update()
#' ### you can pass in many renames
#' gists(what = "minepublic")[[3]] %>%
#'  rename_files(list(file1, "what.md"), list(file2, "new.json")) %>%
#'  update()
#' }

update <- function(gist, description = gist$description, ...) {
  files <- list(update = gist$update_files, add = gist$add_files, 
                delete = gist$delete_files, rename = gist$rename_files)
  body <- payload(filenames = files, description)
  res <- gist_PATCH(id = gist$id, auth = gist_auth(), headers = ghead(), body, ...)
  as.gist(res)
}
