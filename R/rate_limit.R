#' Get rate limit information
#'
#' @export
#' @param ... Named args to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' rate_limit()
#' rate_limit(config=verbose())
#' }

rate_limit <- function(...){
  tmp <- gist_GET(paste0(ghbase(), "/rate_limit"), gist_auth(), ghead(), NULL, ...)
  structure(tmp, class = "gist_rate")
}

#' @export
print.gist_rate <- function(x, ...){
  cat("Rate limit: ", x$rate$limit, '\n', sep = "")
  cat("Remaining:  ", x$rate$remaining, '\n', sep = "")
  diff <- difftime(as.POSIXct(x$rate$reset, "UTC", origin = "1970-01-01 00:00.00"), format(Sys.time(), tz = "UTC"), tz = "UTC", units = "secs")
  cat("Resets in:  ", time(diff), "\n", sep = "")
}

time <- function(x) {
  x <- as.integer(x)

  if (x > 3600) {
    paste0(x %/% 3600, " hours")
  } else if (x > 300) {
    paste0(x %/% 60, " minutes")
  } else if (x > 60) {
    paste0(round(x / 60, 1), " minutes")
  } else {
    paste0(x, "s")
  }
}
