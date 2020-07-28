#' Run a .Rmd file
#'
#' @export
#' @param x Input, one of: code wrapped in curly brackets and quotes, a file
#' path to an .Rmd file, or a gist.
#' @param filename Name of the file to create, only used if `code`
#' parameter is used. Default to `code.R`
#' @param knitopts (list) List of variables passed on to
#' [knitr::knit()]
#' @return A path, unless a gist object is passed in, in which case a gist
#' object is returned.
#' @examples \dontrun{
#' # run a local file
#' file <- system.file("examples", "stuff.Rmd", package = "gistr")
#' run(file) %>% gist_create
#'
#' # run code
#' run({'
#' ```{r}
#' x <- letters
#' (numbers <- runif(8))
#' ```
#' '}) %>% gist_create
#'
#' # run a file from a gist, has to get file first
#' gists('minepublic')[[2]] %>% run() %>% update()
#' }

run <- function(x, filename="code.R", knitopts=list()){
  if (inherits(x, "gist")) {
    ff <- check_files(x)
    code <- get_raw(ff$raw_url)
    files <- file.path(tempdir(), ff$filename)
    writeLines(code, files)
  } else {
    if (!is.character(x)) {
      stop("If not of class gist, input must by of class character")
    } else {
      if (file.exists(x)) {
        ext <- tolower(gsub('^.*[.]', "", basename(x)))
        if (ext != "rmd") stop("File must have extension .Rmd or .rmd")
        files <- x
      } else {
        files <- code_handler(x, filename)
        files <- tempfile(fileext = ".Rmd")
        writeLines(x, files)
      }
    }
  }

  outpath <- do.call(
    knitr::knit,
    c(
      input = files,
      output = sub("\\.Rmd", "\\.md", files),
      knitopts
    )
  )
  if (inherits(x, 'gist')) x %>% update_files(outpath) else outpath
}

check_files <- function(x) {
  if (length(x$files) > 1) {
    stop("You can only feed one file to run()")
  } else {
    x$files[[1]]
  }
}

get_raw <- function(path, ...) {
  res <- cVERB("get", path, gist_auth(), ghead(), ...)
  res$raise_for_status()
  stopifnot(res$headers$`content-type` == 'text/plain; charset=utf-8')
  res$parse("UTF-8")
}
