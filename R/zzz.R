# Function that takes a list of files and creates payload for API
# @importFrom jsonlite toJSON auto_unbox
# @param filenames names of files to post
# @param description brief description of gist (optional)
payload <- function(filenames, description = "") {
  add <- filenames$add
  update <- filenames$update
  delete <- filenames$delete
  rename <- filenames$rename
  fnames <- c(unl(add), unl(update), unl(delete), unr(rename))
  add_update <- lapply(c(add, update), function(file) {
    list(content = paste(readLines(file, warn = FALSE), collapse = "\n"))
  })
  del <- lapply(delete, function(file) structure("null", names=file))
  ren <- lapply(rename, function(f) {
    tt <- f[[1]]
    list(filename = basename(f[[2]]),
         content = paste(readLines(tt, warn = FALSE), collapse = "\n"))
  })
  files <- c(add_update, del, ren)
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

ghead <- function(){
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

gist_POST <- function(url, auth, headers, body, ...){
  response <- POST(url, auth, headers, body=body, encode = "json", ...)
  process(response)
}

gist_PUT <- function(url, auth, headers, ...){
  PUT(url, auth, headers, ...)
}

gist_DELETE <- function(url, auth, headers, ...){
  DELETE(url, auth, headers, ...)
}

process <- function(x){
  stopifnot(x$headers$`content-type` == 'application/json; charset=utf-8')
  warn_for_status(x)
  temp <- content(x, as = "text")
  jsonlite::fromJSON(temp, FALSE)
}

check_auth <- function(x) if(!missing(x)) x else gist_auth()
