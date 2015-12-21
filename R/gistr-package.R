#' R client for GitHub gists.
#'
#' gistr allows you to peform actions on gists, including listing, forking, starring, creating,
#' deleting, updating, etc.
#'
#' There are two ways to authorise gistr to work with your GitHub account:
#'
#' \itemize{
#'  \item Generate a personal access token (PAT) at
#'  \url{https://help.github.com/articles/creating-an-access-token-for-command-line-use}
#'  and record it in the \code{GITHUB_PAT} envar.
#'  \item Interactively login into your GitHub account and authorise with OAuth.
#' }
#'
#' Using the \code{GITHUB_PAT} is recommended.
#'
#' @importFrom magrittr %>%
#' @importFrom knitr knit
#' @importFrom rmarkdown render
#' @importFrom httr GET POST PATCH PUT DELETE content stop_for_status 
#' add_headers warn_for_status
#' @importFrom assertthat assert_that has_extension
#' @importFrom dplyr rbind_all as_data_frame 
#' @importFrom jsonlite flatten
#' @importFrom utils browseURL file.edit
#' @importFrom methods is
#' @importFrom stats setNames
#' @name gistr-package
#' @aliases gistr
#' @docType package
#' @title R client for GitHub gists
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Ramnath Vaidyanathan \email{ramnath.vaidya@@gmail.com}
#' @author Karthik Ram \email{karthik.ram@@gmail.com}
#' @keywords package
NULL

#' @title Create gists
#'
#' @description Creating gists in \code{gistr} can be done with any of 
#' three functions:
#' 
#' \itemize{
#'  \item \code{\link{gist_create}} - Create gists from files or code blocks, using 
#'  the GitHub HTTP API. Because this function uses the GitHub HTTP API, it does not
#'  work for binary files. However, you can get around this for images by using knitr's
#'  hook to upload images to eg., imgur. In addition, it's difficult to include artifacts
#'  from the knit-ing process.
#'  \item \code{\link{gist_create_git}} - Create gists from files or code blocks, using 
#'  git. Because this function uses git, you have more flexibility than with the above 
#'  function: you can include any binary files, and can easily upload all artifacts.
#'  \item \code{\link{gist_create_obj}} - Create gists from R objects: data.frame, list, 
#'  character string, matrix, or numeric. Uses the GitHub HTTP API.
#' }
#' 
#' It may seem a bit odd to have three separate functions for creating gists. 
#' \code{\link{gist_create}} was created first, and was out for a bit, so when we
#' had the idea to create gists via git (\code{\link{gist_create_git}}) and from R 
#' objects (\code{\link{gist_create_obj}}), it made sense to have a different API for 
#' creating gists via the HTTP API, git, and from R objects. We could have thrown 
#' everything into \code{\link{gist_create}}, but it would have been a massive function, 
#' with far too many parameters. 
#'
#' @name create_gists
NULL
