#' Create a gist
#'
#' @export
#' @param files Files to upload
#' @param description (character) Brief description of gist (optional)
#' @param public (logical) Whether gist is public (default: TRUE)
#' @param browse (logical) To open newly create gist in default browser (default: TRUE)
#' @param code Pass in any set of code
#' @param filename Name of the file to create, only used if \code{code} parameter is used. Default
#' to \code{code.R}
#' @param ... Further args passed on to \code{link[httr]{POST}}
#' @examples \donttest{
#' gist_create(files="~/stuff.md", description='a new cool gist')
#' gist_create(files=c("~/spocc_sp.Rmd","~/spocc_sp.md"), description='spocc demo files')
#' 
#' # include any code by passing to the code parameter
#' gist_create(code={'
#' x <- letters
#' numbers <- runif(10)
#' numbers
#' '})
#' 
#' # or include results if you want, and change the filename in this case
#' gist_create(code={'
#' x <- letters
#' numbers <- runif(8)
#' numbers
#' 
#' [1] 0.3229318 0.5933054 0.7778408 0.3898947 0.1309717 0.7501378 0.3206379 0.3379005
#' '}, filename="my_cool_code.R")
#' }

gist_create <- function(files=NULL, description = "", public = TRUE, browse = TRUE, code=NULL,
  filename="code.R", ...)
{
  if(!is.null(code)) files <- code_handler(code, filename)  
  body <- creategist(files, description, public)
  res <- gist_POST(paste0(ghbase(), '/gists'), gist_auth(), ghead(), body, ...)
  gist <- as.gist(res)
  if(browse) browse(gist)
  return( gist )
}

code_handler <- function(x, filename){
  # Remove surrounding `{`
  if (identical(x[[1]], "{")) {
    x <- as.list(x[-c(1,length(x))])
  } else {
    x <- list(x)
  }
  text <- unlist(lapply(x, function(y) gsub("^\\s+|\\s+$|\n\r", "", y)))
  tmp <- file.path(tempdir(), filename)
  writeLines(text, tmp)
  return(tmp)
}
