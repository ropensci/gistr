#' Add files to a gist object
#'
#' @export
#' @examples \dontrun{
#' add_files(files="~/stuff.Rmd")
#' add_files(files=c("~/bunnycheese.txt","~/texas.txt","~/stuff.Rmd"))
#' }

add_files <- function(.gist, files)
{
  .gist <- if(!missing(.gist)) .gist else gist()
  files <- files_exist(files)
  structure(list(auth=.gist$auth, files=files), class="gist")
}

files_exist <- function(x){
  tmp <- sapply(x, file.exists)
  if(!all(tmp)){
    notfound <- paste0(names(tmp[!tmp]), collapse = "\n")
    stop(sprintf("These don't exist or can't be found:\n%s", notfound), call. = FALSE)
  } else { x }
}
