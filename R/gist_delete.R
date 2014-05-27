#' Delete a gist
#' 
#' @param id Gist id
#' @param verbose Print messages (default TRUE)
#' @export
#' @examples \dontrun{
#' gist_delete(id='42095d9a661b0eefc694')
#' }
gist_delete <- function(id, verbose=TRUE){
  credentials = get_credentials()
  url <- sprintf('https://api.github.com/gists/%s', id)
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  response <- DELETE(url, config = c(auth, headers))
  if(!response$status_code == 204){ message(response$headers$statusmessage) } else {
    assert_that(response$headers$statusmessage == 'No Content')
    mssg(verbose, 'Your gist has been deleted')
  }
}