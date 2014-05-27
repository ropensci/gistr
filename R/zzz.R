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