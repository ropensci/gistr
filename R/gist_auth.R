#' Authorize with GitHub.
#'
#' This function is run automatically to allow gistr to access your GitHub
#' account.
#'
#' There are two ways to authorise gistr to work with your GitHub account:
#'
#' - Generate a personal access token with the gist scope selected, and set it
#' as the `GITHUB_PAT` environment variable per session using `Sys.setenv`
#' or across sessions by adding it to your `.Renviron` file or similar.
#' See
#' https://help.github.com/articles/creating-an-access-token-for-command-line-use
#' for help
#' - Interactively login into your GitHub account and authorise with OAuth.
#'
#' Using `GITHUB_PAT` is recommended.
#'
#' @export
#' @param app An [httr::oauth_app()] for GitHub. The default uses an
#' application `gistr_oauth` created by Scott Chamberlain.
#' @param reauth (logical) Force re-authorization?
#' @return a named list, with a single slot for `Authorization`, with a single
#' element with the token - this is the expected format needed when passed
#' down to the http request
#' @examples \dontrun{
#' gist_auth()
#' }

gist_auth <- function(app = gistr_app, reauth = FALSE) {

  #if there is a token cached, use that
  if (exists("auth_config", envir = cache) && !reauth) {
    return(auth_header(cache$auth_config$auth_token))
  }
  #if nothing cached, use gitcreds.  gitcreds will retrieve PAT stored as an
  #GITHUB_PAT environment variable or one set with gitcreds::gitcreds_set()
  #TODO use tryCatch here to customize error message to be more helpful
  # cli::cli_alert_warning("Please set {.field GITHUB_PAT} in your {.file .Renviron} or use the {.pkg gitcreds}
  creds <- try(gitcreds::gitcreds_get())
  if (!inherits(creds, "try-error")) {
    token <- creds$password
  } else if (interactive()) { #if no gitcreds, try interactive authentication
    # try oauth direct
    endpt <- httr::oauth_endpoints("github")
    auth <- httr::oauth2.0_token(endpt, app, scope = "gist", cache = !reauth)
    token <- auth$credentials$access_token
  } else {
    stop("In non-interactive environments, please set GITHUB_PAT env to a GitHub",
         " access token (https://help.github.com/articles/creating-an-access-token-for-command-line-use)",
         call. = FALSE)
  }

  #cache auth config
  auth_config <- httr::config(token = token)
  cache$auth_config <- auth_config
  return(auth_header(auth_config$auth_token))
}

auth_header <- function(x) list(Authorization = paste0("token ", x))

cache <- new.env(parent = emptyenv())

gistr_app <- httr::oauth_app(
  "gistr_oauth",
  "89ecf04527f70e0f9730",
  "77b5970cdeda925513b2cdec40c309ea384b74b7"
)
