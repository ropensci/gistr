#' List gist commits
#' 
#' @export
#' @param id Gist id.
#' @param page (integer) Page number to return.
#' @param per_page (integer) Number of items to return per page. Default 30. Max 100.
#' @template all
#' @examples \dontrun{
#' gist_commits(id='cf5d2e572faafb4c6d5f')
#' # just 1 commit
#' gist_commits(id='cf5d2e572faafb4c6d5f', per_page=1)
#' }

gist_commits <- function(id=NULL, page=NULL, per_page=30, verbose=TRUE, callopts=list())
{  
  credentials <- get_credentials()
  url <- sprintf('https://api.github.com/gists/%s/commits', id)
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  args <- gist_compact(list(page=page, per_page=per_page))
  response <- GET(url, query=args, config = c(auth, headers), callopts)
  assert_that(response$headers$`content-type` == 'application/json; charset=utf-8')
  warn_for_status(response)
  temp <- content(response, as = "text")
  out <- fromJSON(temp)
  return( out )
}