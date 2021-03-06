% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gists.R
\name{gists}
\alias{gists}
\title{List gists}
\usage{
gists(what = "public", since = NULL, page = NULL, per_page = 30, ...)
}
\arguments{
\item{what}{(character) What gists to return. One of public, minepublic,
mineall, or starred. If an id is given for a gist, this parameter is ignored.}

\item{since}{(character) A timestamp in ISO 8601 format:
YYYY-MM-DDTHH:MM:SSZ. Only gists updated at or after this time are returned.}

\item{page}{(integer) Page number to return.}

\item{per_page}{(integer) Number of items to return per page. Default 30.
Max 100.}

\item{...}{Curl options passed on to \code{\link[crul]{verb-GET}}}
}
\description{
List public gists, your own public gists, all your gists, by gist id, or
query by date.
}
\details{
When \code{what = "mineall"}, we use
\code{getOption("github.username")} internally to get your GitHub user name.
Make sure to set your GitHub user name
as an R option like \code{options(github.username = "foobar")} in your
\code{.Rprofile} file. If we can't find you're user name, we'll stop with an
error.
}
\examples{
\dontrun{
# Public gists
gists()
gists(per_page=2)
gists(page=3)
# Public gists created since X time
gists(since='2014-05-26T00:00:00Z')
# Your public gists
gists('minepublic')
gists('minepublic', per_page=2)
# Your private and public gists
gists('mineall')
# Your starred gists
gists('starred')
# pass in curl options
gists(per_page=1, verbose=TRUE)
}
}
