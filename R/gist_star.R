#' Star a gist
#' 
#' @param id Gist id
#' @param what (character) One of star (default), unstar, or check.
#' @template all
#' @export
#' @examples \dontrun{
#' gist_star(id='7698648')
#' gist_star(id='7698648', what='check')
#' gist_star(id='7698648', what='unstar')
#' gist_star(id='7698648', what='check')
#' }
gist_star <- function(id, what='star', verbose=TRUE, callopts=list()){
  credentials <- get_credentials()
  url <- sprintf('https://api.github.com/gists/%s/star', id)
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  what <- match.arg(what, c('star','unstar','check'))
  fxn <- switch(what, star='PUT', unstar='DELETE', check='GET')
  response <- eval(parse(text = fxn))(url, config = c(auth, headers), callopts)
#   assert_that(response$headers$statusmessage == 'No Content')
  if(what=='check'){
    if(response$status_code == 204) TRUE else FALSE
  } else {
    if(response$status_code == 204){ 
      switch(what, star='Success, gist starred', unstar='Success, gist unstarred')
    } else {
      warn_for_status(response)
    }
  }
}