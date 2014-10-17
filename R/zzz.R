# Function that takes a list of files and creates payload for API
# @importFrom jsonlite toJSON auto_unbox
# @param filenames names of files to post
# @param description brief description of gist (optional)
payload <- function(filenames, description = "") {
  add <- filenames$add
  edit <- filenames$edit
  delete <- filenames$delete
  rename <- filenames$rename
  fnames <- c(unl(add), unl(edit), unl(delete), unr(rename))
  add_edit <- lapply(c(add, edit), function(file) {
    list(content = paste(readLines(file, warn = FALSE), collapse = "\n"))
  })
  del <- lapply(delete, function(file) structure("null", names=file))
#   ren <- lapply(rename, function(file) list(filename = strsplit(file, "/")[[1]][2]))
  ren <- lapply(rename, function(f) {
    tt <- f[[1]]
    list(filename = basename(f[[2]]), 
         content = paste(readLines(tt, warn = FALSE), collapse = "\n"))
  })
  files <- c(add_edit, del, ren)
  names(files) <- basename(fnames)
  body <- list(description = description, files = files)
  jsonlite::toJSON(body, auto_unbox = TRUE)
}

creategist <- function(filenames, description = "", public = TRUE) {
  filenames <- files_exist(filenames)
  files <- lapply(filenames, function(file) {
    list(content = paste(readLines(file, warn = FALSE), collapse = "\n"))
  })
  names(files) <- basename(filenames)
  body <- list(description = description, public = public, files = files)
  jsonlite::toJSON(body, auto_unbox = TRUE)
}

unl <- function(x) if(!is.null(x)) do.call(c, x) else NULL
unr <- function(x) if(!is.null(x)) unname(sapply(x, function(z) z[[1]])) else NULL

mssg <- function(x, y) if(x) message(y)

gist_compact <- function(l) Filter(Negate(is.null), l)

ghbase <- function() 'https://api.github.com'

gist_header <- function(){
  add_headers(`User-Agent` = "gistr", `Accept` = 'application/vnd.github.v3+json')
}

gist_GET <- function(url, auth, headers, args=list(), ...){
  response <- GET(url, auth, headers, query=args, ...)
  process(response)
}

gist_PATCH <- function(id, auth, headers, body, ...){
  response <- PATCH(paste0(ghbase(), '/gists/', id), auth, headers, body=body, encode = "json", ...)
  process(response)
}

gist_POST <- function(auth, headers, body, ...){
  response <- POST(paste0(ghbase(), '/gists'), auth, headers, body=body, encode = "json", ...)
  process(response)
}

gist_DELETE <- function(id, auth, headers, ...){
  DELETE(paste0(ghbase(), '/gists/', id), auth, headers, ...)
}

process <- function(x){
  stopifnot(x$headers$`content-type` == 'application/json; charset=utf-8')
  warn_for_status(x)
  temp <- content(x, as = "text")
  jsonlite::fromJSON(temp, FALSE)
}

check_auth <- function(x) if(!missing(x)) x else gist_oauth()
