#' List gists
#' 
#' You can list public gists, your public gists, or all your gists
#' 
#' @importFrom RJSONIO fromJSON
#' @export
#' @param id Gist id.
#' @param what (character) What gists to return. One of public, minepublic, mineall, or starred. 
#' If an id is given for a gist, this parameter is ignored.
#' @param since (character) A timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ. Only gists 
#' updated at or after this time are returned.
#' @param page (integer) Page number to return.
#' @param per_page (integer) Number of items to return per page. Default 30. Max 100.
#' @template all
#' @examples \dontrun{
#' # Public gists
#' gist_get()
#' gist_get(per_page=1)
#' gist_get(page=3)
#' # Public gists created since X time
#' gist_get(since='2014-05-26T00:00:00Z')
#' # Your public gists
#' gist_get(what='minepublic')
#' gist_get(what='minepublic', per_page=2)
#' # Your private and public gists
#' gist_get(what='mineall')
#' # A single gist
#' gist_get(id='cf5d2e572faafb4c6d5f')
#' # Your starred gists
#' gist_get(what='starred') 
#' # pass in curl options
#' gist_get(per_page=1, callopts=verbose())
#' gist_get(per_page=1, callopts=timeout(seconds = 0.5))
#' }

gist_get <- function(id=NULL, what='public', since=NULL, page=NULL, per_page=30, 
                     verbose=TRUE, callopts=list())
{  
  credentials <- get_credentials()
  if(!is.null(id)) what <- "id"
  url <- switch(what, 
         public = 'https://api.github.com/gists/public',
         minepublic = 'https://api.github.com/gists',
         mineall = sprintf('https://api.github.com/users/%s/gists/', getOption("github.username")),
         starred = 'https://api.github.com/gists/starred',
         id = sprintf('https://api.github.com/gists/%s', id)) 
  headers <- add_headers(`User-Agent` = "Dummy", `Accept` = 'application/vnd.github.v3+json')
  auth  <- authenticate(getOption("github.username"), getOption("github.password"), type = "basic")
  args <- gist_compact(list(since=since, page=page, per_page=per_page))
  response <- GET(url, query=args, config = c(auth, headers), callopts)
  assert_that(response$headers$`content-type` == 'application/json; charset=utf-8')
  warn_for_status(response)
  temp <- content(response, as = "text")
  out <- fromJSON(temp)
  return( out )
}