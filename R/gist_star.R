#' Star a gist
#' 
#' @param id Gist id
#' @param verbose Print messages (default TRUE)
#' @export
#' @examples \dontrun{
#' gist_star(id='2f9eb6b72730fed2f061')
#' }
gist_star <- function(id, verbose=TRUE){
  credentials = get_credentials()
  url <- sprintf('https://api.github.com/gists/%s/star', id)
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  response <- PUT(url, config = c(auth, headers))
  if(!response$status_code == 204){ message(response$headers$statusmessage) } else {
    assert_that(response$headers$statusmessage == 'No Content')
    mssg(verbose, 'Your gist has been deleted')
  }
}