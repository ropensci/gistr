#' Post a gist object
#'
#' @export
#' @examples \dontrun{
#' post(description='My gist!', public=TRUE)
#' }

post <- function(.gist, description = "", public = TRUE, verbose=TRUE, browse=TRUE, ...)
{
  .gist <- if(!missing(.gist)) .gist else gist()
  tmp <- create_gist(.gist$files, description = description, public = public)
  response <- POST("https://api.github.com/gists", body = tmp, config = c(.gist$auth, gist_header(), ...))
  warn_for_status(response)
  stopifnot(response$headers$`content-type` == 'application/json; charset=utf-8')
  html_url <- content(response)$html_url
  gisturl <- paste("https://gist.github.com/", getOption("github.username"), "/", 
                   basename(html_url), sep = "")
  embedurl <- paste("<script src=\"https://gist.github.com/", getOption("github.username"),
                    "/", basename(html_url), ".js\"></script>", sep = "")
  message("Your gist has been published")
  message("View gist at ", gisturl)
  message("Embed gist with ", embedurl)
  browseURL(gisturl)
  return( gisturl )
}
