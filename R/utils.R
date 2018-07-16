#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @usage lhs \%>\% rhs
NULL

# Hadley shorthand to handle nulls with defaults
`%||%` <- function(x, y) {
  if (is.null(x)) {
    y 
  } else {
    x
  }
}
