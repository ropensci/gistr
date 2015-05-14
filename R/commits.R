#' List gist commits
#'
#' @export
#' @param gist A gist object or something coerceable to a gist
#' @param page (integer) Page number to return.
#' @param per_page (integer) Number of items to return per page. Default 30. Max 100.
#' @param ... Further named args to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' gists()[[1]] %>% commits()
#' gist(id = '1f399774e9ecc9153a6f') %>% commits(per_page = 5)
#' 
#' # pass in a url
#' gist("https://gist.github.com/expersso/4ac33b9c00751fddc7f8") %>% commits
#' }

commits <- function(gist, page=NULL, per_page=30, ...) {
  gist <- as.gist(gist)
  args <- gist_compact(list(page = page, per_page = per_page))
  res <- gist_GET(sprintf('%s/gists/%s/commits', ghbase(), gist$id), gist_auth(), ghead(), args, ...)
  lapply(res, structure, class = "commit")
}

#' @export
print.commit <- function(x, ...){
  cat("<commit>\n", sep = "")
  cat("  Version: ", x$version, "\n", sep = "")
  cat("  User: ", x$user$login, "\n", sep = "")
  cat("  Commited: ", x$committed_at, "\n", sep = "")
  cat("  Commits [total, additions, deletions]: ",
    sprintf("[%s,%s,%s]", x$change_status$total, x$change_status$additions, x$change_status$deletions),
    "\n", sep = "")
}
