#' Get embed script for a gist
#' 
#' @export
#' @param gist A gist object or something that can be coerced to a gist object.
#' @examples \donttest{
#' gists()[[1]] %>% embed()
#' }
embed <- function(gist){
  gist <- as.gist(gist)
  paste("<script src=\"https://gist.github.com/", gist$owner$login,
        "/", basename(gist$html_url), ".js\"></script>", sep = "")
}
