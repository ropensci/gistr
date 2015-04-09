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
#' We also provide an interface to GitHub Gists using git, bypassing the http API.
#' This path is much easier if you already use git locally. If not, you'll have to 
#' setup some git options. See \url{https://github.com/ropensci/git2r#configuration}
#'
#' @name gistr-package
#' @aliases gistr
#' @docType package
#' @title R client for GitHub gists
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Ramnath Vaidyanathan \email{ramnath.vaidya@@gmail.com}
#' @author Karthik Ram \email{karthik.ram@@gmail.com}
#' @keywords package
NULL
