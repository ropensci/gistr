#' Delete a gist
#'
#' @export
#' @param x A gist object or something coerceable to a gist
#' @template all
#' 
#' @examples \dontrun{
#' gists("minepublic")[[29]] %>% delete()
#' }
delete <- function(x, ...) UseMethod("delete")

#' @export
#' @rdname delete
delete.gist <- function(x, ...)
{
  gist <- as.gist(x)
  res <- gist_DELETE(paste0(ghbase(), '/gists/', gist$id), auth = gist_auth(), headers = ghead(), ...)
  stop_for_status(res)
  message('Your gist has been deleted')
}

#' @export
#' @rdname delete
delete.tbl <- function(x, ...) invisible(lapply(x$id, delgist, ...))

delgist <- function(z, ...){
  res <- gist_DELETE(paste0(ghbase(), '/gists/', z), auth = gist_auth(), headers = ghead(), ...)
  warn_for_status(res)
}
