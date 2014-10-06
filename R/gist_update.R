#' Update/modify a gist
#' 
#' @export
#' @param id Gist id
#' @template gistargs
#' @template all
#' @examples \dontrun{
#' gist_update(id='42095d9a661b0eefc694')
#' }
gist_update <- function(id, files=NULL, description = "", public = TRUE, 
                        verbose=TRUE, callopts=list())
{
  dat <- create_gist(files, description = description, public = public)
  credentials = get_credentials()
  url <- sprintf('https://api.github.com/gists/%s', id)
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  response <- PATCH(url, body = dat, config = c(auth, headers), callopts)
  warn_for_status(response)
  stopifnot(response$headers$`content-type` == 'application/json; charset=utf-8')
  html_url = content(response)$html_url
  message('Your gist has been updated')
  invisible(basename(html_url))
}