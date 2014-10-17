#' Add files to a gist object
#'
#' @export
#' @rdname files
#' 
#' @param gist A gist object or something coerceable to a gist
#' @template all
#' @examples \donttest{
#' add_files("~/stuff.Rmd")
#' edit_files()
#' delete_files()
#' rename_files()
#' }

add_files <- function(gist, ...)
{
  files <- list(...)
  files <- files_exist(files)
  gist$add_files <- files
  gist
}

#' @export
#' @rdname files
edit_files <- function(gist, ...)
{
  files <- list(...)
  files <- files_exist(files)
  gist$edit_files <- files
  gist
}

#' @export
#' @rdname files
delete_files <- function(gist, ...)
{
  files <- list(...)
  files <- files_exist(files)
  gist$delete_files <- files
  gist
}

#' @export
#' @rdname files
rename_files <- function(gist, ...)
{
  gist$rename_files <- list(...)
  gist
}

files_exist <- function(x){
  tmp <- sapply(x, file.exists)
  if(!all(tmp)){
#     notfound <- paste0(names(tmp[!tmp]), collapse = "\n")
    notfound <- paste0(x[!tmp], collapse = "\n")
    stop(sprintf("These don't exist or can't be found:\n%s", notfound), call. = FALSE)
  } else { x }
}
