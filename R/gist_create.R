#' Create a gist
#'
#' @export
#' @importFrom knitr knit 
#' @importFrom rmarkdown render
#' @template args
#' @seealso \code{\link{gist_create_git}}, \code{\link{gist_create_obj}}
#' @examples \dontrun{
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
#' base <- "http://pelias.mapzen.com/search"
#' res <- GET(base, query = list(input = 'coffee shop', lat = 45.5, lon = -122.6))
#' json <- content(res, as = "text")
#' gist_create(code = json, filename = "pelias_test.geojson")
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
#' ## if not, GitHub doesn't allow upload of binary files via the HTTP API (which gistr uses)
#' ## but check back later as I'm working on an option to get binary files uploaded, 
#' ## but will involve having to use git
#' file <- system.file("examples", "plots.Rmd", package = "gistr")
#' gist_create(file, knit=TRUE, imgur_inject = TRUE)
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
#' gist_create(files=list(file1, file2, file3), knit = TRUE, include_source = TRUE)
#' }

gist_create <- function(files=NULL, description = "", public = TRUE, browse = TRUE, code=NULL,
  filename="code.R", knit=FALSE, knitopts=list(), renderopts=list(), include_source = FALSE, 
  imgur_inject = FALSE, ...) {
  
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
      ff <- knit_render(ff, knitopts, renderopts)
      if (include_source) ff <- c(orig_files, ff)
      allfiles[[i]] <- ff
    }
  } else {
    allfiles <- files
  }
  is_binary(allfiles)
  is_dir(allfiles)
  body <- creategist(unlist(allfiles), description, public)
  res <- gist_POST(paste0(ghbase(), '/gists'), gist_auth(), ghead(), body, ...)
  gist <- as.gist(res)
  if (browse) browse(gist)
  return( gist )
}

knit_render <- function(x, knitopts, renderopts) {
  if (grepl("\\.[rR]md$|\\.[rR]nw$", x)) {
    ext <- "knitr"
  } else if (grepl("\\.[rR]$", x)) {
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
      str <- "```{r echo=FALSE}\nknitr::opts_knit$set(upload.fun = imgur_upload, base.url = NULL)\n```\n"
      cat(str, orig, file = x, sep = "\n")
    } 
    #     else if(grepl("\\.[rR]nw$", x)) {
    #       str <- "```{r echo=FALSE}\nknitr::opts_knit$set(upload.fun = imgur_upload, base.url = NULL)\n```\n"
    #       cat(str, orig, file = x, sep = "\n")
    #     }
  }
}

inject_root_dir <- function(x, path) {
  orig <- readLines(x)
  cat(sprintf("```{r echo=FALSE}
              knitr::opts_knit$set(root.dir = \"%s\")
              ```\n", path), orig, file = x, sep = "\n")
}

# swapfilename <- function(x, filename){
#   tmp <- strsplit(x, "/")[[1]]
#   paste0(paste0(tmp[ - length(tmp) ], collapse = "/"), ,filename)
# }

code_handler <- function(x, filename){
  # Remove surrounding `{`
  if (identical(x[[1]], "{")) {
    x <- as.list(x[-c(1, length(x))])
  } else {
    x <- list(x)
  }
  text <- unlist(lapply(x, function(y) gsub("^\\s+|\\s+$|\n\r", "", y)))
  tmp <- file.path(tempdir(), filename)
  writeLines(text, tmp)
  return(tmp)
}

is.binary <- function(x, maximum = 1000) {
  if (!is.dir(x)) {
    f <- file(x, "rb", raw = TRUE)
    b <- readBin(f, "int", maximum, size = 1, signed = FALSE)
    tmp <- suppressWarnings(max(b)) > 128
    close.connection(f)
    tmp
  } else {
    FALSE
  }
}

is_binary <- function(x) {
  bin <- vapply(x, is.binary, logical(1))
  if (any(bin)) {
    stop("Binary files not supported\n", x[bin], call. = FALSE)
  }
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
