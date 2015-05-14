#' Star a gist
#'
#' @export
#' @param gist A gist object or something that can be coerced to a gist object.
#' @template all
#' @return A message, and a gist object, the same one input to the function.
#' @examples \dontrun{
#' id <- '7ddb9810fc99c84c65ec'
#' gist(id) %>% star()
#' gist(id) %>% star_check()
#' gist(id) %>% unstar()
#' gist(id) %>% unstar() %>% star()
#' gist(id) %>% star_check()
#' gist(id) %>%
#'   star() %>%
#'   star_check()
#'   
#' # pass in a url
#' x <- "https://gist.github.com/expersso/4ac33b9c00751fddc7f8"
#' gist(x) %>% star
#' gist(x) %>% unstar
#' }

star <- function(gist, ...){
  gist <- as.gist(gist)
  res <- gist_PUT(url_star(gist$id), gist_auth(), ghead(), add_headers(`Content-Length` = 0), ...)
  star_mssg(res, 'Success, gist starred!')
  gist
}

#' @export
#' @rdname star
unstar <- function(gist, ...){
  gist <- as.gist(gist)
  res <- gist_DELETE(url_star(gist$id), gist_auth(), ghead(), ...)
  star_mssg(res, 'Success, gist unstarred!')
  gist
}

#' @export
#' @rdname star
star_check <- function(gist, ...){
  gist <- as.gist(gist)
  res <- GET(url_star(gist$id), gist_auth(), ghead(), ...)
  msg <- if(res$status_code == 204) TRUE else FALSE
  message(msg)
  gist
}

url_star <- function(x) sprintf('%s/gists/%s/star', ghbase(), x)

star_mssg <- function(x, y) if(x$status_code == 204) message(y) else warn_for_status(x)

star_action <- function(x, y){
  if(x$status_code == 204) switch(y, star="starred", unstar="unstarred") else x$status_code
}
