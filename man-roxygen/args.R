#' @param files Files to upload
#' @param description (character) Brief description of gist (optional)
#' @param public (logical) Whether gist is public (default: TRUE)
#' @param browse (logical) To open newly create gist in default browser (default: TRUE)
#' @param code Pass in any set of code. This can be a single R object, or many lines of code
#' wrapped in quotes, then curly brackets (see examples below).
#' @param filename Name of the file to create, only used if \code{code} parameter is used. Default
#' to \code{code.R}
#' @param knit (logical) Knit code before posting as a gist? If the file has a \code{.Rmd} 
#' or \code{.Rnw} extension, we run the file with \code{link[knitr]{knit}}, and if it has
#' a \code{.R} extension, then we use \code{\link[rmarkdown]{render}}
#' @param knitopts,renderopts (list) List of variables passed on to \code{link[knitr]{knit}},
#' or \code{\link[rmarkdown]{render}}
#' @param include_source (logical) Only applies if \code{knit=TRUE}. Include source file in the
#' gist in addition to the knitted output.
#' @param imgur_inject (logical) Inject \code{\link[knitr]{imgur_upload}} into your
#' \code{.Rmd} file to upload files to \url{http://imgur.com/}. This will be ignored 
#' if the file is a sweave/latex file because the rendered pdf can't be uploaded
#' anyway. Default: FALSE
#' @param ... Further args passed on to \code{link[httr]{POST}}
