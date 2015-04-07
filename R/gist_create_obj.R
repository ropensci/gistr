#' Create a gist from an R object
#'
#' @export
#'
#' @param x An R object, any of data.frame, matrix, list, character, numeric
#' @param description (character) Brief description of gist (optional)
#' @param public (logical) Whether gist is public (default: TRUE)
#' @param browse (logical) To open newly create gist in default browser (default: TRUE)
#' @param pretty (logical) For data.frame and matrix objects, create 
#' a markdown table. If FALSE, pushes up json. (default: TRUE)
#' @param ... Further args passed on to \code{link[httr]{POST}}
#' @details This function is specifically for going from R objects to a gist, whereas 
#' \code{\link{gist_create}} is for going from files or executing code
#' @examples \dontrun{
#' ## data.frame
#' ### by default makes pretty table in markdown format
#' row.names(mtcars) <- NULL
#' gist_create_obj(mtcars)
#' gist_create_obj(iris)
#' ### or just push up json
#' gist_create_obj(mtcars, pretty = FALSE)
#' 
#' ## matrix
#' gist_create_obj(as.matrix(mtcars))
#' ## list
#' gist_create_obj(apply(mtcars, 1, as.list))
#' ## character
#' gist_create_obj("hello, world")
#' ## numeric
#' gist_create_obj(runif(10))
#' }

gist_create_obj <- function(x = NULL, description = "", public = TRUE, 
                            browse = TRUE, pretty = TRUE, ...) {
  UseMethod("gist_create_obj")
}

gist_create_obj.data.frame <- function(x = NULL, description = "", public = TRUE,
                                       browse = TRUE, pretty = TRUE, ...) {
  gc_robjs(x, description, public, browse, pretty, ...)
}

gist_create_obj.character <- function(x = NULL, description = "", public = TRUE, 
                                      browse = TRUE, pretty = TRUE, ...) {
  gc_robjs(x, description, public, browse, pretty, ...)
}

gist_create_obj.list <- function(x = NULL, description = "", public = TRUE,
                                 browse = TRUE, pretty = TRUE, ...) {
  gc_robjs(x, description, public, browse, pretty, ...)
}

gist_create_obj.matrix <- function(x = NULL, description = "", public = TRUE,
                                   browse = TRUE, pretty = TRUE, ...) {
  gc_robjs(x, description, public, browse, pretty, ...)
}

gist_create_obj.numeric <- function(x = NULL, description = "", public = TRUE, 
                                    browse = TRUE, pretty = TRUE, ...) {
  gc_robjs(x, description, public, browse, pretty, ...)
}

gc_robjs <- function(x, description, public, browse, pretty, ...) {
  body <- creategist_obj(x, description, public, pretty)
  res <- gist_POST(paste0(ghbase(), '/gists'), gist_auth(), ghead(), body, ...)
  gist <- as.gist(res)
  if (browse) browse(gist)
  return( gist )
}
