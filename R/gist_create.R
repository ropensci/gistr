#' Create a gist
#'
#' @export
#' @param files Files to upload
#' @param description (character) Brief description of gist (optional)
#' @param public (logical) Whether gist is public (default: TRUE)
#' @param browse (logical) To open newly create gist in default browser (default: TRUE)
#' @param ... Further args passed on to \code{link[httr]{POST}}
#' @examples \donttest{
#' gist_create(files="~/stuff.md", description='a new cool gist')
#' gist_create(files=c("~/spocc_sp.Rmd","~/spocc_sp.md"), description='spocc demo files')
#' }

gist_create <- function(files, description = "", public = TRUE, browse = TRUE, ...)
{
  body <- creategist(files, description, public)
  res <- gist_POST(gist_auth(), ghead(), body, ...)
  gist <- as.gist(res)
  if(browse) browse(gist)
  return( gist )
}
