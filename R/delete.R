#' Delete a gist
#' 
#' @param id Gist id
#' @template all
#' @export
#' @examples \dontrun{
#' gists("minepublic")[[1]] %>% delete()
#' }

delete <- function(gist, ...)
{
  gist <- as.gist(gist)
  res <- gist_DELETE(gist$id, gist_oauth(), ghead(), ...)
  if(!res$status_code == 204){ message(res$headers$statusmessage) } else {
    stopifnot(res$headers$statusmessage == 'No Content')
    mssg(verbose, 'Your gist has been deleted')
  }
}
