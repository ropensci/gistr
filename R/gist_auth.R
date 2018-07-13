#' Authorize with GitHub.
#'
#' This function is run automatically to allow gistr to access your GitHub 
#' account.
#'
#' There are two ways to authorise gistr to work with your GitHub account:
#' \itemize{
#'  \item Generate a personal access token at
#'    \url{https://help.github.com/articles/creating-an-access-token-for-command-line-use} 
#'    and record in the \code{GITHUB_PAT} envar.
#'  \item Interactively login into your GitHub account and authorise with OAuth.
#' }
#'
#' Using \code{GITHUB_PAT} is recommended.
#'
#' @export
#' @param app An \code{\link[httr]{oauth_app}} for GitHub. The default uses an 
#' application \code{gistr_oauth} created by Scott Chamberlain.
#' @param reauth (logical) Force re-authorization?
#' @param env_pat (character) Name of environment variable that contains
#' a GitHub PAT (Personal Access Token), defaults to \code{"GITHUB_PAT"}.
#' Useful to specify with GitHub Enterprise, e.g. \code{"GITHUB_ACME_PAT"}.
#' @examples \dontrun{
#' gist_auth()
#' }

gist_auth <- function(app = gistr_app, reauth = FALSE, env_pat = NULL) {
 
  if (exists("auth_config", envir = cache) && !reauth) {
    return(cache$auth_config)
  }

  # argument used for GitHub Enterprise (GHE)
  # env_pat: name of environment variable to find PAT for GHE 
  #          (handled here)
  env_pat <- env_pat %||% "GITHUB_PAT"

  pat <- Sys.getenv(env_pat, "")
  if (!identical(pat, "")) {
    auth_config <- httr::add_headers(Authorization = paste0("token ", pat))
  } else if (!interactive()) {
    stop("In non-interactive environments, please set GITHUB_PAT env to a GitHub",
         " access token (https://help.github.com/articles/creating-an-access-token-for-command-line-use)",
         call. = FALSE)
  } else  {
    endpt <- httr::oauth_endpoints("github")
    token <- httr::oauth2.0_token(endpt, app, scope = "gist", cache = !reauth)
    auth_config <- httr::config(token = token)
  }
  cache$auth_config <- auth_config
  auth_config
}

cache <- new.env(parent = emptyenv())

gistr_app <- httr::oauth_app(
  "gistr_oauth",
  "89ecf04527f70e0f9730",
  "77b5970cdeda925513b2cdec40c309ea384b74b7"
)
