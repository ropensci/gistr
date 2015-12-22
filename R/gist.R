#' Get a gist
#'
#' @export
#' @param id (character) A gist id, or a gist URL
#' @param x Object to coerce. Can be an integer (gist id), string
#'   (gist id), a gist, or an list that can be coerced to a gist.
#' @template all
#' @details If a file is larger than ~1 MB, the content of the file given back 
#' is truncated, so you won't get the entire contents. In the return S3 object
#' that's printed, we tell you at the bottom whether each file is truncated or 
#' not. If a file is, simply get the \code{raw_url} URL for the file (see 
#' example below), then retrieve from that. If the file is very big, you may 
#' need to clone the file using git, etc. 
#' @examples \dontrun{
#' gist('f1403260eb92f5dfa7e1')
#'
#' as.gist('f1403260eb92f5dfa7e1')
#' as.gist(10)
#' as.gist(gist('f1403260eb92f5dfa7e1'))
#'
#' # from a url, or partial url
#' x <- "https://gist.github.com/expersso/4ac33b9c00751fddc7f8"
#' x <- "gist.github.com/expersso/4ac33b9c00751fddc7f8"
#' x <- "gist.github.com/4ac33b9c00751fddc7f8"
#' x <- "expersso/4ac33b9c00751fddc7f8"
#' as.gist(x)
#' 
#' ids <- sapply(gists(), "[[", "id")
#' gist(ids[1])
#' gist(ids[2])
#' gist(ids[3])
#' gist(ids[4])
#'
#' gist(ids[1]) %>% browse()
#' 
#' ## If a gist file is > a certain size it is truncated
#' ## in this case, we let you know in the return object that it is truncated
#' ## e.g.
#' (bigfile <- gist(id = "b74b878fd7d9176a4c52"))
#' ## then get the raw_url, and retrieve the file
#' url <- bigfile$files$`plossmall.json`$raw_url
#' # httr::GET(url)
#' }

gist <- function(id, ...){
  res <- gist_GET(switch_url('id', normalize_id(id)), gist_auth(), ghead(), ...)
  as.gist(res)
}

#' @export
#' @rdname gist
as.gist <- function(x) UseMethod("as.gist")

#' @export
as.gist.gist <- function(x) x

#' @export
as.gist.numeric <- function(x) gist(x)

#' @export
as.gist.character <- function(x) {
  if (is_url(x)) {
    x <- get_gistid(x)
  }
  gist(x)
}

#' @export
as.gist.list <- function(x) list2gist(x)

normalize_id <- function(x) {
  if (is_url(x) || is_gisturl(x)) {
    get_gistid(x)
  } else {
    x
  }
}

is_gisturl <- function(x){
  str1 <- "^gist\\.github\\.com/[A-Za-z0-9]+/[0-9a-z]+$"
  str2 <- "^gist\\.github\\.com/[0-9a-z]+$"
  str3 <- "^[A-Za-z0-9]+/[0-9a-z]+$"
  grepl(paste(str1, str2, str3, sep = "||"), x, ignore.case = TRUE)
}

is_url <- function(x){
  grepl("https?://", x, ignore.case = TRUE) || grepl("localhost:[0-9]{4}", x, ignore.case = TRUE)
}

get_gistid <- function(x) {
  strextract(x, "[0-9a-z]+$")
}

list2gist <- function(x){
  nmz <- c('comments','comments_url','commits_url','created_at','description',
           'files','forks_url','git_pull_url','git_push_url','html_url','id',
           'public','truncated','updated_at','url','user')
  if (!all(sort(nmz) %in% sort(names(x)))) {
    stop("Not coerceable to a gist", call. = FALSE)
  }
  structure(x, class = "gist")
}

#' @export
print.gist <- function(x, ...){
  cat("<gist>", x$id, "\n", sep = "")
  cat("  URL: ", x$html_url, "\n", sep = "")
  cat("  Description: ", x$description, "\n", sep = "")
  cat("  Public: ", x$public, "\n", sep = "")
  cat("  Created/Edited: ", x$created_at, " / ", x$updated_at, "\n", sep = "")
  cat("  Files: ", paste0(vapply(x$files, "[[", "", "filename"), collapse = ", "), "\n", sep = "")
  cat("  Truncated?: ", paste0(sapply(x$files, is_trunc), collapse = ", "), "\n", sep = "")
}

is_trunc <- function(z) {
  if (is.null(z$truncated)) {
    FALSE
  } else {
    z$truncated
  }
}
