#' List gists
#'
#' List public gists, your own public gists, all your gists, by gist id, or query by date.
#'
#' @export
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
#' gists(per_page=2)
#' gists(page=3)
#' # Public gists created since X time
#' gists(since='2014-05-26T00:00:00Z')
#' # Your public gists
#' gists('minepublic')
#' gists('minepublic', per_page=2)
#' # Your private and public gists
#' gists('mineall')
#' # Your starred gists
#' gists('starred')
#' # pass in curl options
#' gists(per_page=1, config=verbose())
#' gists(per_page=1, config=timeout(seconds = 0.5))
#' }

gists <- function(what='public', since=NULL, page=NULL, per_page=30, ...) {
  args <- gist_compact(list(since = since, page = page, per_page = per_page))
  if (length(args) == 0) args <- NULL
  res <- gist_GET(switch_url(what), gist_auth(), ghead(), args, ...)
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
