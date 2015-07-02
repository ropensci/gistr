gistr 0.3.0
===============

### NEW FEATURES

* Gained new function `gistr_save()` to save gist files to disk easily and optionally open them in your editor/R GUI (#47). In addition, files saved to a directory, with the dir named by the gist id (#49)
* `gist()` now accepts either a gist ID or full or partial URL's for a gist (#48)

### MINOR IMPROVEMENTS

* Can now optionally use `rmarkdown::render()` with `gist_create()` (#52)
* Explicitly import non-base R pkg functions, so importing from `utils`, `methods`, and `stats` (#53)
* Can now toggle use of `rmarkdown` package with a parameter in `gist_create()` (#52)
* Better error messages from the GitHub API (#42)

### BUG FIXES

* Fixed problem with `httr` `v1` where empty list not allowed to pass to 
the `query` parameter in `GET` (#51)

gistr 0.2.0
===============

### NEW FEATURES

* `gistr_create()` can now optionally include source file if `knit=TRUE` using the new
parameter `include_source` (#19)
* new function `gist_create_obj()` to create a gist directly from a R object, like
numeric, list, character, data.frame, matrix (#36) (#44)
* new function `gist_map()` to open a full page map in your default browser of a gist
after gist creation (#23)
* new function `tabl()` (weird function name to avoid the `table` function in base R).
This function goal is to make it easier to play with gist data. Data given back from the
GitHub API is great, but is in nested list format (after conversion from JSON) - so
is rather hard to manipulate. `tabl()` makes a data.frame from output of `gist()`,
`gists()`, `as.gist()`, and `commits()` (#25)

### MINOR IMPROVEMENTS

* `gistr_create()` works with `.Rnw` files, and example `.Rnw` file included in the package. (#20)
* Added ability in `gist_create()` to optionally include the source file passed into
the function call when `knit=TRUE` (#19)
* Added ability to inject imgur hooks into a knitted document so that images can be rendered in a gist automatically. The GitHub HTTP API doesn't allow binary uploads
(e.g., images), so the parameter `imgur_inject` uploads your images to imgur
and embeds links to the images in your document. (#33)
* Improved information on truncation. If you request a gist that is larger than 1MB,
the returned object says it's truncated. You can download the whole thing using
the `raw_url`, or for larger than 10 MB to the `git_pull_url`. (#26)

### BUG FIXES

* Fixed unicode problem on Windows (#37)
* Improved error catching (#28)
* `gist_create()` now works for an R script, didn't before (#29)

gistr 0.1.0
===============

### NEW FEATURES

* released to CRAN
