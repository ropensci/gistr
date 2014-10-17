#' Open a gist on GitHub
#' 
#' @export
#' @param gist A gist object or something that can be coerced to a gist object.
#' @param what One of html (default), json, forks, commits, or comments. 

browse <- function(gist, what="html"){
  gist <- as.gist(gist)
  url <- switch(what, 
         html="html_url", json="url", forks="forks_url", commits="commits_url", comments="comments_url")
  browseURL(gist[[url]])
}
