#' Post a file as a Github gist
#'
#' @import httr RJSONIO assertthat
#' @export
#' @template gistargs
#' @template all
#' @param browse (logical) If TRUE, created gist opens in your default browser.
#' @description
#' You will be asked to enter you Github credentials (username, password) during
#' each session, but only once for each session. Alternatively, you could enter
#' your credentials into your .Rprofile file with the entries
#'
#' \enumerate{
#'  \item options(github.username = 'your_github_username')
#'  \item options(github.password = 'your_github_password')
#' }
#'
#' then \code{gist} will simply read those options internally.
#'
#' @return Posts your file as a gist on your account, and prints out the url for the
#' gist and for embedding the gist in the console.
#' 
#' @examples \dontrun{
#' gist_create(files="stuff.md", description='My gist!', public=TRUE)
#' gist_create(files=c("spocc_sp.Rmd","spocc_sp.md"), description='spocc demo files', public=TRUE)
#' }

gist_create <- function(files, description = "", public = TRUE, verbose=TRUE, browse=TRUE) {
  dat <- create_gist(files, description = description, public = public)
  credentials <- get_credentials()
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  response <- POST(url = "https://api.github.com/gists", body = dat, config = c(auth, headers))
  warn_for_status(response)
  assert_that(response$headers$`content-type` == 'application/json; charset=utf-8')
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