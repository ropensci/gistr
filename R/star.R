#' Star a gist
#' 
#' @export
#' 
#' @param .gist gist object
#' @param id Gist id
#' @template all
#' @examples \dontrun{
#' id <- '7ddb9810fc99c84c65ec'
#' gist() %>% star(id = id)
#' gist() %>% star_check(id = id)
#' gist() %>% unstar(id = id)
#' gist() %>% star_check(id = id)
#' gist() %>%
#'   star(id = id) %>%
#'   star_check(id = id)
#' }

star <- function(.gist, id, ...){
  auth <- check_auth(.gist)
  response <- PUT(url_star(id), auth$auth, c(gist_header(), add_headers(`Content-Length` = 0)), ...)
  star_mssg(response, 'Success, gist starred!')
  structure(c(.gist$auth, gist_id=id, gist_star=star_action(response, "star")), class="gist")
}

#' @export
#' @rdname star
unstar <- function(.gist, id, ...){
  auth <- check_auth(.gist)
  response <- DELETE(url_star(id), auth$auth, gist_header(), ...)
  star_mssg(response, 'Success, gist unstarred!')
}

#' @export
#' @rdname star
star_check <- function(.gist, id, ...){
  auth <- check_auth(.gist)
  response <- GET(url_star(id), auth$auth, gist_header())
  if(response$status_code == 204) TRUE else FALSE
}

url_star <- function(x) sprintf('%s/gists/%s/star', ghbase(), x)

star_mssg <- function(x, y) if(x$status_code == 204) message(y) else warn_for_status(x)

star_action <- function(x, y){
  if(x$status_code == 204) switch(y, star="starred", unstar="unstarred") else x$status_code
}
