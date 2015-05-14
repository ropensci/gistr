#' Save gist files to disk
#'
#' @export
#' @param gist A gist object or something coerceable to a gist
#' @param path Root path to write to, a directory, not a file b/c a gist can contain 
#' many files. A folder is created with name of the gist id within this root 
#' directory.  File names will be the same as given in the gist.
#' @param x An object of class \code{gist_files} (the output from \code{gist_save})
#' @return An object of class \code{gist_files}, S3 object containing file paths
#' @details 
#' \code{gist_save}: files are written into a new folder, named by the gist id, 
#' e.g., \code{a65ac7e56b7b3f746913}
#' 
#' \code{gist_open}: opens files in your editor/R GUI. Internally, uses 
#' \code{\link{file.edit}} to open files, using \code{getOption("editor")} to 
#' open the files. If you're in R.app or RStudio, or other IDE's, files will 
#' open in the IDE (I think).
#' @examples \dontrun{
#' gist("a65ac7e56b7b3f746913") %>% gist_save()
#' gist("a65ac7e56b7b3f746913") %>% gist_save() %>% gist_open()
#' gist("https://gist.github.com/expersso/4ac33b9c00751fddc7f8") %>% gist_save()
#' }

gist_save <- function(gist, path = ".") {
  gist <- as.gist(gist)
  if (!isDir(path)) stop("path does not exist: ", path, call. = FALSE)
  path <- file.path(path.expand(path), gist$id)
  dir.create(path, showWarnings = FALSE, recursive = TRUE)
  if (is.null(gist$files) || length(gist$files) == 0) {
    stop("no files to write", call. = FALSE)
  }
  files <- list()
  for (i in seq_along(gist$files)) {
    x <- gist$files[[i]]
    files[[i]] <- writepath <- file.path(path, x$filename)
    writeLines(x$content, writepath)
  }
  structure(unlist(files), class = "gist_files", id = gist$id)
}

#' @export
print.gist_files <- function(x, ...) {
  cat("<gist> ", attr(x, "id"), "\n", sep = "")
  # cat("  Files: \n", paste0(strx, collapse = "\n"), "\n", sep = "")
  cat(g_wrap(sprintf("Files:\n %s ...", paste0(x, collapse = "\n")), indent = 3), "\n\n")
}

g_wrap <- function(..., indent = 0, width = getOption("width")) {
  x <- paste0(..., collapse = "")
  wrapped <- strwrap(x, indent = indent, exdent = indent + 2, width = width)
  paste0(wrapped, collapse = "\n")
}

#' @export
#' @rdname gist_save
gist_open <- function(x) {
  stopifnot(is(x, "gist_files"))
  invisible(lapply(x, file.edit))
}

isDir <- function(path) {
  if (!is.string(path)) stop("path is not a string: ", path, call. = FALSE)
  if (!file.exists(path)) stop("path does not exist: ", path, call. = FALSE)
  file.info(path)$isdir
}

is.string <- function(x) { 
  is.character(x) && length(x) == 1
}
