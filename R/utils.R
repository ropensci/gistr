#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @usage lhs \%>\% rhs
NULL

# borrows %||% from Hadley
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
