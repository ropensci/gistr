#' Get embed script for a gist
#'
#' @export
#' @param gist A gist object or something that can be coerced to a gist object.
#' @examples \dontrun{
#' gists()[[1]] %>% embed()
#' 
#' # pass in a url
#' gist("https://gist.github.com/expersso/4ac33b9c00751fddc7f8") %>% embed
#' }
embed <- function(gist){
  gist <- as.gist(gist)
  paste("<script src=\"https://gist.github.com/", gist$owner$login,
        "/", basename(gist$html_url), ".js\"></script>", sep = "")
}
