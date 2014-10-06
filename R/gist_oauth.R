#' Authorize with GitHub.
#'
#' This function is run automatically to allow analogsea to access your
#' GitHub account.
#'
#' There are two ways to authorise gistr to work with your GitHub account:
#' \itemize{
#' \item Generate a personal access token at 
#'   \url{https://cloud.digitalocean.com/settings/tokens/new} and 
#'   record in the \code{DO_PAT} envar.
#'   
#' \item Interactively login into your DO account and authorise with
#'   OAuth.
#' }
#'
#' Using \code{DO_PAT} is recommended.
#'
#' @export
#' @param app An \code{\link[httr]{oauth_app}} for DO. The default uses the 
#'   standard ROpenSci application. 
#' @param reauth (logical) Force re-authorization? 
#' @examples \donttest{
#' gist_oauth()
#' }

gist_oauth <- function(app = gistr_app, reauth = FALSE) {
  
  if (exists("auth_config", envir = cache) && !reauth) {
    return(cache$auth_config)
  }
  pat <- Sys.getenv("GITHUB_PAT", "")
  if (!identical(pat, "")) {
    auth_config <- httr::add_headers(Authorization = paste0("Bearer ", pat))
  } else if (!interactive()) {
    stop("In non-interactive environments, please set GITHUB_PAT env to a GitHug",
         " access token (https://help.github.com/articles/creating-an-access-token-for-command-line-use)",
         call. = FALSE)
  } else  {
    endpt <- httr::oauth_endpoint(NULL, "authorize", "token",
                                  base_url = "https://github.com/login/oauth")
    token <- httr::oauth2.0_token(endpt, app, scope = c("read", "write"), cache = !reauth)
    auth_config <- httr::config(token = token)
  }  
  cache$auth_config <- auth_config
  auth_config
}

cache <- new.env(parent = emptyenv())

gistr_app <- httr::oauth_app(
  "gist_oauth", 
  "89ecf04527f70e0f9730",
  "77b5970cdeda925513b2cdec40c309ea384b74b7"
)
