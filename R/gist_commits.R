#' List gist commits
#' 
#' @export
#' @param .gist gist object
#' @param id Gist id.
#' @param page (integer) Page number to return.
#' @param per_page (integer) Number of items to return per page. Default 30. Max 100.
#' @param ... Further named args to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' gist_commits(id='cf5d2e572faafb4c6d5f')
#' # just 1 commit
#' gist_commits(id='cf5d2e572faafb4c6d5f', per_page=1)
#' }

gist_commits <- function(.gist, id=NULL, page=NULL, per_page=30, ...)
{
  auth <- if(!missing(.gist)) .gist$auth else gist_oauth()
  url <- sprintf('%s/gists/%s/commits', ghbase(), id)
  args <- gist_compact(list(page=page, per_page=per_page))
  gist_GET(url, .gist$auth, gist_header(), args, ...)
}
