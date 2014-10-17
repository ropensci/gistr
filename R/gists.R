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
#' gists()
#' gists(per_page=1)
#' gists(page=3)
#' # Public gists created since X time
#' gists(since='2014-05-26T00:00:00Z')
#' # Your public gists
#' gists(what='minepublic')
#' gists(what='minepublic', per_page=2)
#' # Your private and public gists
#' gists(what='mineall')
#' # A single gist
#' gists(id='cf5d2e572faafb4c6d5f')
#' # Your starred gists
#' gists(what='starred')
#' # pass in curl options
#' gists(per_page=1, config=verbose())
#' gists(per_page=1, config=timeout(seconds = 0.5))
#' }

gists <- function(id=NULL, what='public', since=NULL, page=NULL, per_page=NULL, verbose=TRUE, ...)
{
  if(!is.null(id)) what <- "id"
  args <- gist_compact(list(since=since, page=page, per_page=per_page))
  res <- gist_GET(switch_url(what, id), gist_oauth(), ghead(), args, ...)
  lapply(res, structure, class = "gist")
}

switch_url <- function(x, id){
  switch(x,
         public = paste0(ghbase(), '/gists/public'),
         minepublic = paste0(ghbase(), '/gists'),
         mineall = sprintf('%s/users/%s/gists', ghbase(), getOption("github.username")),
         starred = paste0(ghbase(), '/gists/starred'),
         id = sprintf('%s/gists/%s', ghbase(), id))
}

ghead <- function(){
  add_headers(`User-Agent` = "gistr", `Accept` = 'application/vnd.github.v3+json')
}
