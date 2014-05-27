#' Post a file as a Github gist
#'
#' @import httr RJSONIO
#' @export
#' @param gist An object
#' @param description brief description of gist (optional)
#' @param public whether gist is public (default: TRUE)
#' @description
#' You will be asked ot enter you Github credentials (username, password) during
#' each session, but only once for each session. Alternatively, you could enter
#' your credentials into your .Rprofile file with the entries
#'
#' \enumerate{
#'  \item options(github.username = 'your_github_username')
#'  \item options(github.password = 'your_github_password')
#' }
#'
#' then \code{gist} will simply read those options.
#'
#' \code{gist} was modified from code in the rCharts package by Ramnath Vaidyanathan
#' @return Posts your file as a gist on your account, and prints out the url for the
#' gist itself in the console.
#' @examples \dontrun{
#' gist_create(files="stuff.md", description='My gist!', public=TRUE)
#' }

gist_create <- function(gist, description = "", public = TRUE) {
  dat <- create_gist(gist, description = description, public = public)
  credentials <- get_credentials()
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  response <- POST(url = "https://api.github.com/gists", body = dat, config = c(auth, headers))
  warn_for_status(response)
  assert_that(response$headers$`content-type` == 'application/json; charset=utf-8')
  html_url <- content(response)$html_url
  message("Your gist has been published")
  message("View gist at ", paste("https://gist.github.com/", getOption("github.username"),
                                 "/", basename(html_url), sep = ""))
  message("Embed gist with ", paste("<script src=\"https://gist.github.com/", getOption("github.username"),
                                    "/", basename(html_url), ".js\"></script>", sep = ""))
  return(paste("https://gist.github.com/", getOption("github.username"), "/", basename(html_url),
               sep = ""))
}