#' Update/modify a gist
#' 
#' @param id Gist id
#' @param verbose Print messages (default TRUE)
#' @export
#' @examples \dontrun{
#' gist_update(id='42095d9a661b0eefc694')
#' }
gist_update <- function(gist, id, description = "", public = TRUE){
  dat <- create_gist(gist, description = description, public = public)
  credentials = get_credentials()
  url <- sprintf('https://api.github.com/gists/%s', id)
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  response <- PATCH(url, body = gist, config = c(auth, headers))
  warn_for_status(response)
  assert_that(response$headers$`content-type` == 'application/json; charset=utf-8')
  html_url = content(response)$html_url
  message('Your gist has been updated')
  invisible(basename(html_url))
}