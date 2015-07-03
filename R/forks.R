#' List forks on a gist
#'
#' @export
#' @param gist A gist object or something coerceable to a gist
#' @param page (integer) Page number to return.
#' @param per_page (integer) Number of items to return per page. Default 30. Max 100.
#' @param ... Further named args to \code{\link[httr]{GET}}
#' @return A list of gist class objects
#' @examples \dontrun{
#' gist(id='1642874') %>% forks(per_page=2)
#' gist(id = "8172796") %>% forks()
#' 
#' # pass in a url
#' gist("https://gist.github.com/expersso/4ac33b9c00751fddc7f8") %>% forks 
#' }

forks <- function(gist, page=NULL, per_page=30, ...) {
  gist <- as.gist(gist)
  args <- gist_compact(list(page = page, per_page = per_page))
  if (length(args) == 0) args <- NULL
  res <- gist_GET(sprintf('%s/gists/%s/forks', ghbase(), gist$id), gist_auth(), ghead(), args, ...)
  lapply(res, structure, class = "gist")
}

#' Fork a gist
#'
#' @export
#' @param gist A gist object or something coerceable to a gist
#' @param ... Further named args to \code{\link[httr]{GET}}
#' @return A gist class object
#' @examples \dontrun{
#' # fork a gist
#' gists()[[1]] %>% fork()
#'
#' # browse to newly forked gist
#' gist(id='0831f3fbd83ac4d46451') %>% fork() %>% browse()
#'
#' # extract the last one
#' gist(id='1642874') %>%
#'  forks() %>%
#'  .[length(.)]
#' }

fork <- function(gist, ...) {
  gist <- as.gist(gist)
  res <- gist_POST(sprintf('%s/gists/%s/fork', ghbase(), gist$id), gist_auth(), ghead(), list(), ...)
  structure(res, class = "gist")
}
