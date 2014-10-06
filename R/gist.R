#' Gist setup
#' 
#' @export
#' @param ... Pararms passed to \code{gist_oauth}

gist <- function(...){
  auth <- gist_oauth(...)
  structure(list(auth = auth, files = NULL), class="gist")
}
