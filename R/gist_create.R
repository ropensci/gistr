#' Create a gist
#'
#' @export
#' @param files Files to upload
#' @param description (character) Brief description of gist (optional)
#' @param public (logical) Whether gist is public (default: TRUE)
#' @examples \donttest{
#' gist_create(files="~/stuff.md", description='a new cool gist')
#' gist_create(files=c("~/spocc_sp.Rmd","~/spocc_sp.md"), description='spocc demo files')
#' }

gist_create <- function(files, description = "", public = TRUE, browse = TRUE, ...)
{
  body <- creategist(files, description, public)
  res <- gist_POST(gist_oauth(), ghead(), body, ...)
  gist <- as.gist(res)
  browse(gist)
  return( gist )
}

embed <- function(gist){
  gist <- as.gist(gist)
  paste("<script src=\"https://gist.github.com/", gist$owner$login,
        "/", basename(gist$html_url), ".js\"></script>", sep = "")
}
