#' Make a table from gist or commit class or a list of either
#' 
#' @export
#' @importFrom dplyr rbind_all as_data_frame 
#' @importFrom jsonlite flatten
#' @param x Either a gist or commit class object or a list of either
#' @examples \dontrun{
#' x <- as.gist('f1403260eb92f5dfa7e1')
#' tabl(x)
#' 
#' # from a list
#' ss <- gists('minepublic')
#' tabl(ss[1:3])
#' ## manipulate with dplyr
#' library("dplyr")
#' tabl(gists("minepublic")[1:10]) %>% 
#'   select(id, description, owner_login) %>% 
#'   filter(grepl("gist gist gist", description))
#' 
#' # commits
#' x <- gists()[[2]] %>% commits()
#' tabl(x[[1]])
#' 
#' ## many
#' x <- sapply(c(gists(), gists()), commits)
#' tabl(x) %>%
#'   select(id, login, change_status.total, url) %>% 
#'   filter(change_status.total > 50)
#' }
tabl <- function(x) {
  UseMethod("tabl")
}

#' @export
tabl.gist <- function(x){
  singles <- move_cols(data.frame(null2na(x[ names(x) %in% snames ]), stringsAsFactors = FALSE), "id")
  others <- x[ !names(x) %in% snames ]
  files <- lappdf(others$files, "files")
  owner <- data.frame(others$owner, stringsAsFactors = FALSE)
  owner <- if(NROW(owner) == 0) owner else setNames(owner, paste0("owner_", names(owner)))
  forks <- lappdf(others$forks, "forks")
  history <- lappdf(others$history, "history")
  as_data_frame(cbind_fill(singles, files, owner, forks, history, as_df = TRUE))
}

#' @export
tabl.list <- function(x) {
  if(any(sapply(x, class) == "list")) {
    x <- unlist(x, recursive = FALSE)
  }
  suppressWarnings(rbind_all(lapply(x, tabl)))
}

#' @export
tabl.commit <- function(m){
  as_data_frame(move_cols(
    do.call("cbind", gist_compact(list(null2na(m$user), 
                          flatten(data.frame(null2na(pop(unclass(m), "user")), 
                                             stringsAsFactors = FALSE))))), "id"))
}

snames <- c("url","forks_url", "commits_url", "id", "git_pull_url",
            "git_push_url", "html_url", "public", "created_at",
            "updated_at", "description", "comments", "user", "comments_url")

lappdf <- function(x, prefix = NULL) {
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

null2na <- function(w) {
  if (is.null(w)) {
    NULL
  } else {
    w[sapply(w, is.null)] <- NA
    w[sapply(w, length) == 0] <- NA
    w
  }
}

cbind_fill <- function(..., as_df = FALSE) {
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

move_cols <- function(x, y) {
  if (y %in% names(x)) {
    x[ c(y, names(x)[-sapply(y, function(z) grep(paste0('\\b', z, '\\b'), names(x)))]) ]
  } else {
    x
  }
}
