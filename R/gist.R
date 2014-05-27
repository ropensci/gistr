#' Post a file as a Github gist
#'
#' @import httr
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
#' @keywords internal
#' @export

gist_post <- function(gist, description = "", public = TRUE) {
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

#' Function that takes a list of files and creates payload for API
#'
#' @importFrom RJSONIO toJSON
#' @param filenames names of files to post
#' @param description brief description of gist (optional)
#' @param public whether gist is public (defaults to TRUE)
#' @keywords internal
create_gist <- function(filenames, description = "", public = TRUE) {
  files <- lapply(filenames, function(file) {
    x <- list(content = paste(readLines(file, warn = FALSE), collapse = "\n"))
  })
  names(files) <- basename(filenames)
  body <- list(description = description, public = public, files = files)
  RJSONIO::toJSON(body)
}

#' Get Github credentials from use in console
#' @keywords internal
get_credentials <- function() {
  if (is.null(getOption("github.username"))) {
    username <- readline("Please enter your github username: ")
    options(github.username = username)
  }
  if (is.null(getOption("github.password"))) {
    password <- readline("Please enter your github password: ")
    options(github.password = password)
  }
}

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

#' Handler to print messages or not via verbose parameter in all fxns
#' @keywords internal
mssg <- function(x, y) if(x) message(y)

# #' Response handler
# #' @keywords internal
# res_handler <- function(x){
#   if(!x$status_code == 200){
#     stnames <- names(content(x))
#     if(!is.null(stnames)){
#       if('developerMessage' %in% stnames|'message' %in% stnames){
#         warning(sprintf("Error: (%s) - %s", x$status_code, 
#                         noaa_compact(list(content(x)$developerMessage, content(x)$message))))
#       } else { warning(sprintf("Error: (%s)", x$status_code)) }
#     } else { warn_for_status(x) }
#   } else {
#     assert_that(x$headers$`content-type`=='application/json;charset=UTF-8')
#     res <- content(x, as = 'text', encoding = "UTF-8")
#     out <- jsonlite::fromJSON(res, simplifyVector = FALSE)
#     if(!'results' %in% names(out)){
#       if(length(out)==0){ warning("Sorry, no data found") }
#     } else {
#       if( class(try(out$results, silent=TRUE))=="try-error" | is.null(try(out$results, silent=TRUE)) )
#         warning("Sorry, no data found")
#     }
#     return( out )
#   }
# }