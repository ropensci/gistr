#' Make a table from gist class or list of gist class objects
#' 
#' @export
#' @importFrom dplyr rbind_all
#' @param x Either a gist class object or a list of many gist class objects
#' @examples \dontrun{
#' x <- as.gist('f1403260eb92f5dfa7e1')
#' tbl(x)
#' 
#' # from a list
#' ss <- gists('minepublic')
#' tbl(ss[1:3])
#' ## manipulate with dplyr
#' library("dplyr")
#' tbl(gists("minepublic")[1:4]) %>% 
#'   select(id, description, owner_login) %>% 
#'   filter(grepl("gist gist gist", description)) %>% 
#'   delete
#' }
tbl <- function(x) UseMethod("tbl")

#' @export
#' @rdname tbl
tbl.gist <- function(x){
  singles <- move_cols(data.frame(null2na(x[ names(x) %in% snames ]), stringsAsFactors = FALSE), "id")
  others <- x[ !names(x) %in% snames ]
  files <- lappdf(others$files, "files")
  owner <- data.frame(others$owner, stringsAsFactors = FALSE)
  owner <- if(NROW(owner) == 0) owner else setNames(owner, paste0("owner_", names(owner)))
  forks <- lappdf(others$forks, "forks")
  history <- lappdf(others$history, "history")
  cbind_fill(singles, files, owner, forks, history, as_df = TRUE)
}

#' @export
#' @rdname tbl
tbl.list <- function(x) rbind_all(lapply(x, tbl))

snames <- c("url","forks_url", "commits_url", "id", "git_pull_url",
            "git_push_url", "html_url", "public", "created_at",
            "updated_at", "description", "comments", "user", "comments_url")

lappdf <- function(x, prefix=NULL){
  tmp <- data.frame(rbind_all(lapply(x, function(z){
    data.frame(null2na(z), stringsAsFactors=FALSE)
  })), stringsAsFactors=FALSE)
  if(!is.null(prefix)){
    if(NROW(tmp) == 0){
      tmp
    } else {
      setNames( tmp, paste0(prefix, "_", names(tmp)) )
    }
  } else {
    tmp
  }
}

null2na <- function(x){
  x[sapply(x, is.null)] <- NA
  x
}

cbind_fill <- function(..., as_df = FALSE){
  nm <- list(...) 
  nm <-lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  temp <- do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(, n-nrow(x), ncol(x))))) 
  if(as_df){
    data.frame(temp, stringsAsFactors = FALSE)
  } else {
    temp
  }
}

move_cols <- function(x, y)
  x[ c(y, names(x)[-sapply(y, function(z) grep(paste0('\\b', z, '\\b'), names(x)))]) ]
