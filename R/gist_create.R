#' Create a gist
#'
#' @export
#' @template args
#' @param rmarkdown (logical) If \code{TRUE}, use 
#' \code{\link[rmarkdown]{render}} instead of \code{\link[knitr]{knit}} to 
#' render the document.
#' @seealso \code{\link{gist_create_obj}}, \code{\link{gist_create_git}}
#' @examples \dontrun{
#' file <- tempfile()
#' cat("hello world", file = file)
#' gist_create(files=file, description='a new cool gist')
#' 
#' file1 <- tempfile()
#' file2 <- tempfile()
#' cat("foo bar", file = file1)
#' cat("foo bar", file = file2)
#' gist_create(files=c(file1, file2), description='spocc demo files')
#'
#' # include any code by passing to the code parameter
#' gist_create(code={'
#' x <- letters
#' numbers <- runif(10)
#' numbers
#' '})
#'
#' # Knit an .Rmd file before posting as a gist
#' file <- system.file("examples", "stuff.Rmd", package = "gistr")
#' gist_create(file, description='a new cool gist', knit=TRUE)
#'
#' file <- system.file("examples", "plots.Rmd", package = "gistr")
#' gist_create(file, description='some plots', knit=TRUE)
#'
#' # an .Rnw file
#' file <- system.file("examples", "rnw_example.Rnw", package = "gistr")
#' gist_create(file)
#' gist_create(file, knit=TRUE)
#'
#' # Knit code input before posting as a gist
#' gist_create(code={'
#' ```{r}
#' x <- letters
#' (numbers <- runif(8))
#' ```
#' '}, knit=TRUE)
#'
#' library('httr')
#' url <- "https://github.com/ropensci/geojsonio/blob/master/inst/examples/zillow_or.geojson"
#' res <- httr::GET(url)
#' json <- httr::content(res, as = "text")
#' gist_create(code = json, filename = "zillow_or.geojson")
#'
#' # Knit and include source file, so both files are in the gist
#' file <- system.file("examples", "stuff.Rmd", package = "gistr")
#' gist_create(file, knit=TRUE, include_source=TRUE)
#'
#' gist_create(code={'
#' ```{r}
#' x <- letters
#' (numbers <- runif(8))
#' ```
#' '}, filename="code.Rmd", knit=TRUE, include_source=TRUE)
#'
#' # Uploading images created during knit process
#' ## using imgur - if you're file uses imgur or similar, you're good
#' file <- system.file("examples", "plots_imgur.Rmd", package = "gistr")
#' cat(readLines(file), sep = "\n") # peek at file
#' gist_create(file, knit=TRUE)
#' ## if not, GitHub doesn't allow upload of binary files via the HTTP API 
#' ## (which gistr uses) - so see gist_create_git(), which uses git
#' file <- system.file("examples", "plots.Rmd", package = "gistr")
#' gist_create(file, knit=TRUE, imgur_inject = TRUE)
#' ## works with ggplot2 as well
#' file <- system.file("examples", "ggplot_imgur.Rmd", package = "gistr")
#' gist_create(file, knit=TRUE)
#'
#' # Render `.R` files
#' file <- system.file("examples", "example1.R", package = "gistr")
#' cat(readLines(file), sep = "\n") # peek at file
#' gist_create(file, knit = TRUE)
#' gist_create(file, knit = TRUE, include_source = TRUE)
#' ## many files
#' (file1 <- system.file("examples", "example1.R", package = "gistr"))
#' (file2 <- system.file("examples", "example2.R", package = "gistr"))
#' cat(readLines(file1), sep = "\n") # peek at file
#' cat(readLines(file2), sep = "\n") # peek at file
#' gist_create(files=list(file1, file2), knit = TRUE)
#' ### three at once, some .R and some .Rmd
#' file3 <- system.file("examples", "plots_imgur.Rmd", package = "gistr")
#' gist_create(files=list(file1, file2, file3), knit = TRUE)
#' gist_create(files=list(file1, file2, file3), knit = TRUE, 
#'   include_source = TRUE)
#' 
#' # Use rmarkdown::render instead of knitr::knit
#' file <- system.file("examples", "rmarkdown_eg.Rmd", package = "gistr")
#' gist_create(file, knit = TRUE, rmarkdown = TRUE, imgur_inject = TRUE,
#'    renderopts = list(output_format = "md_document"))
#' }

gist_create <- function(files=NULL, description = "", public = TRUE, 
  browse = TRUE, code=NULL, filename="code.R", knit=FALSE, knitopts=list(), 
  renderopts=list(), include_source = FALSE, imgur_inject = FALSE, 
  rmarkdown = FALSE, ...) {

  if (is.null(files) && is.null(code)) {
    stop("must use one of 'files' or 'code'", call. = FALSE)
  }
  if (!is.null(code)) files <- code_handler(code, filename)
  if (knit) {
    allfiles <- list()
    for (i in seq_along(files)) {
      ff <- files[[i]]
      dirpath <- dirname(ff)
      orig_files <- ff
      if (!is.null(code)) {
        ff <- tempfile(fileext = ".Rmd")
        writeLines(code, ff)
      }
      inject_imgur(ff, imgur_inject)
      ff <- knit_render(ff, knitopts, renderopts, rmarkdown)
      if (include_source) ff <- c(orig_files, ff)
      allfiles[[i]] <- ff
    }
  } else {
    allfiles <- files
  }
  # is_binary(allfiles)
  is_dir(unlist(allfiles))
  body <- creategist(unlist(allfiles), description, public)
  res <- gist_POST(paste0(ghbase(), '/gists'), gist_auth(), ghead(), body, ...)
  gist <- as.gist(res)
  if (browse) browse(gist)
  return( gist )
}

knit_render <- function(x, knitopts, renderopts, rmarkdown) {
  if (grepl("\\.[rR]md$|\\.[rR]nw$", x)) {
    ext <- "knitr"
  } else if (grepl("\\.[rR]$", x) || rmarkdown) {
    ext <- "rmarkdown"
  }
  switch(ext,
         knitr = {
           do.call(knitr::knit,
                   gc(c(input = x,
                        output = sub("\\.Rmd", "\\.md", x),
                        knitopts)))
         },
         rmarkdown = {
           do.call(rmarkdown::render,
                   c(input = x, renderopts))
         }
  )
}

getpath <- function(z) {
  gsub("^\\(|\\)$", "", strtrim(strextract(z, "\\(.+")))
}

inject_imgur <- function(x, imgur_inject = TRUE) {
  if (!any(grepl("imgur_upload", readLines(x))) && imgur_inject) {
    orig <- readLines(x)
    if (grepl("\\.[rR]md$", x)) {
      str <- "```{r echo=FALSE}\nknitr::opts_knit$set(upload.fun = knitr::imgur_upload, base.url = NULL)\n```\n"
      cat(str, orig, file = x, sep = "\n")
    }
  }
}

inject_root_dir <- function(x, path) {
  orig <- readLines(x)
  cat(sprintf("```{r echo=FALSE}
              knitr::opts_knit$set(root.dir = \"%s\")
              ```\n", path), orig, file = x, sep = "\n")
}

code_handler <- function(x, filename){
  # Remove surrounding `{`
  if (identical(x[[1]], "{")) {
    x <- as.list(x[-c(1, length(x))])
  } else {
    x <- list(x)
  }
  text <- unlist(lapply(x, function(y) gsub("^\\s+|\\s+$|\n\r", "", y)))
  tdir <- temp_gist_dir()
  tmp <- file.path(tdir, filename)
  writeLines(text, tmp)
  return(tmp)
}

temp_gist_dir <- function() {
  ph <- file.path(Sys.getenv("HOME"), paste0(".gistr_code_", 
                                             basename(tempfile())))
  dir.create(ph, showWarnings = FALSE, recursive = TRUE)
  return(ph)
}

is.dir <- function(x) {
  file.info(x)$isdir
}

is_dir <- function(x) {
  bin <- vapply(x, is.dir, logical(1))
  if (any(bin)) {
    stop("Directories not supported\n", x[bin], call. = FALSE)
  }
}
