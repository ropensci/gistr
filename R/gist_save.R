#' Save a gist to disk
#'
#' @export
#' @param gist A gist object or something coerceable to a gist
#' @param path Path to write to, a directory, not a file b/c a gist can contain 
#' many files. File names will be the same as given in the gist
#' @param open_files (logical) If \code{TRUE}, open files in your editor/R GUI. 
#' Default: \code{FALSE}
#' @return file(s) path
#' @examples \dontrun{
#' gist("a65ac7e56b7b3f746913") %>% gist_save()
#' gist("https://gist.github.com/expersso/4ac33b9c00751fddc7f8") %>% gist_save()
#' }

gist_save <- function(gist, path = ".", open_files = FALSE) {
  gist <- as.gist(gist)
  path <- path.expand(path)
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
  if (open_files) {
    invisible(lapply(files, file.edit))
  }
  return(unlist(files))
}
