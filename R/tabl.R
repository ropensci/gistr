#' Make a table from gist or commit class or a list of either
#' 
#' @export
#' @param x Either a gist or commit class object or a list of either
#' @param ... Ignored
#' @return A data.frame or list of data.frame's
#' @details For commits we return a single data.frame. For gists, we always 
#' return a list so that we are returning data consistently, 
#' regardless of variable return data. So you can always index to the main data.frame
#' with gist metadata and file info by doing \code{result$data}, and likewise for 
#' forks \code{result$forks} and history \code{result$history}
#' @examples \dontrun{
#' # from a gist object
#' x <- as.gist('f1403260eb92f5dfa7e1')
#' res <- tabl(x)
#' res$data
#' res$forks
#' res$history
#' 
#' # from a list
#' ss <- gists('minepublic')
#' tabl(ss[1:3])
#' lapply(tabl(ss[1:3]), "[[", "data")
#' # index to data slots, but also make single data.frame
#' tabl_data(tabl(ss[1:3]))
#' ## manipulate with dplyr
#' library("dplyr")
#' tabl_data(tabl(ss[1:30])) %>% 
#'   select(id, description, owner_login) %>% 
#'   filter(grepl("gist gist gist", description))
#' 
#' # commits
#' x <- gists()[[2]] %>% commits()
#' tabl(x[[1]])
#' 
#' ## many
#' x <- sapply(gists(per_page = 100), commits)
#' tabl(x) %>%
#'   select(id, login, change_status.total, url) %>% 
#'   filter(change_status.total > 50)
#'   
#' # pass in a url
#' gist("https://gist.github.com/expersso/4ac33b9c00751fddc7f8") %>% tabl
#' ## many
#' gg <- gists()
#' (urls <- vapply(gg, "[[", "", "html_url"))
#' lapply(urls[1:5], as.gist) %>% tabl()
#' 
#' # gist with forks and history
#' gist('1642874') %>% tabl
#' 
#' # gist with history, no forks
#' gist('c96d2e453c95d0166408') %>% tabl 
#' }
tabl <- function(x, ...) {
  UseMethod("tabl")
}

#' @export
tabl.gist <- function(x, ...){
  others <- x[ !names(x) %in% snames ]
  files <- lappdf(others$files, "files")
  files_n <- NROW(files)
  
  singles <- move_cols(data.frame(null2na(x[ names(x) %in% snames ]), stringsAsFactors = FALSE), "id")
  singles <- repeat_rows(singles, files_n)
  
  owner <- data.frame(others$owner, stringsAsFactors = FALSE)
  owner <- if (NROW(owner) == 0) owner else setNames(owner, paste0("owner_", names(owner)))
  owner <- repeat_rows(owner, files_n)
  
  one <- dplyr::as_data_frame(cbind_fill(singles, files, owner, as_df = TRUE))
  
  forks <- dplyr::as_data_frame(lappdf(others$forks, "forks"))
  history <- dplyr::as_data_frame(lappdf(others$history, "history"))
  
  if (NROW(forks) == 0) forks <- NULL
  if (NROW(history) == 0) history <- NULL
  list(data = one, forks = forks, history = history)
}

repeat_rows <- function(x, n) {
  x <- x[rep(1, each = n), ]
  row.names(x) <- NULL
  x
}

#' @export
#' @rdname tabl
tabl_data <- function(x) {
  stopifnot(is(x, "list"))
  suppressWarnings(dplyr::rbind_all(lapply(x, "[[", "data")))
}

#' @export
tabl.list <- function(x, ...) {
  if (any(sapply(x, class) == "list")) {
    x <- unlist(x, recursive = FALSE)
  }
  res <- lapply(x, tabl)
  if (is(x[[1]], "commit")) {
    suppressWarnings(rbind_all(res))
  } else {
    res
  }
  # suppressWarnings(rbind_all(lapply(x, tabl)))
}

#' @export
tabl.commit <- function(x, ...){
  as_data_frame(move_cols(
    do.call("cbind", gist_compact(list(null2na(x$user), 
                          flatten(data.frame(null2na(pop(unclass(x), "user")), 
                                             stringsAsFactors = FALSE))))), "id"))
}

snames <- c("url","forks_url", "commits_url", "id", "git_pull_url",
            "git_push_url", "html_url", "public", "created_at",
            "updated_at", "description", "comments", "user", "comments_url")

lappdf <- function(x, prefix = NULL) {
  tmp <- data.frame(rbind_all(lapply(x, function(z) {
    data.frame(null2na(z), stringsAsFactors = FALSE)
  })), stringsAsFactors = FALSE)
  if (!is.null(prefix)) {
    if (NROW(tmp) == 0) {
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
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  temp <- do.call(cbind, lapply(nm, function(x) { 
      rbind(x, matrix(, n - nrow(x), ncol(x)))
    })
  ) 
  if (as_df) {
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
