gistr in development
===============

### BUG FIXES

* fix `gist_auth()`: at some point `httr::oauth2.0_token` stopped returning the token in the `headers` slot; can't figure out when this change happened; fix is to get the token from a different place in the returned object; changes to `gist_auth()` to access that new path to the token (#83)


gistr 0.9.0
===============

### MINOR IMPROVEMENTS

* replace httr with crul for all but the oauth handling (#68)
* fix to internal fxn `stopstatus()` to handle correctly detecting scope header issues (#82)
* fixed old urls that have changed


gistr 0.5.0
===============

### MINOR IMPROVEMENTS

* vignette gains an example of round-tripping a data.frame to a gist then back from the gist to a data.frame (#78) (#79) thanks @jsta
* update package docs throughout to tell users to make sure to create a GitHub PAT (personal access token) with gist scope (#80)

### BUG FIXES

* fix to `gist_create()`: fail if both `files` and `code` params are `NULL` (the user should pass something in) (#72) thanks @maelle


gistr 0.4.2
===============

### NEW FEATURES

* `gist()` gains a parameter `revision` to request a specific revision of a gists. note that the returned brief print out of the gist in your console may not vary from revision to revision, but the underlying data has the correct data for the revision (#71)

### MINOR IMPROVEMENTS

* affecting all functions that create data `gist_create()`, `gist_create_git()`, `gist_create_obj()`, `update()`, `delete()`: GitHub for good reason gives a 404 when there are authentication issues. A common problem is that a user has incorrect or missing scopes. We now attempt to detect this scope problem specifically and throw a message when that happens (#70)
* toggle whether we index to a git path with `@` vs. `$` depending on `git2r` package version; for an upcoming version of `git2r` (#74)


gistr 0.4.0
===============

### MINOR IMPROVEMENTS

* Change all `dplyr::rbind_all` instances to `dplyr::bind_rows` (#69)

### BUG FIXES

* Fix to `gists()` internals for when `github.username` not set 
and user selects `what = "mineall"` - now stops with informative
message about setting `github.username` option (#66) (#67) thanks @sboysel


gistr 0.3.6
===============

### MINOR IMPROVEMENTS

* Added more tests for `as.gist()`

### BUG FIXES

* Fix to `as.gist.list()` method to not break sometimes when not all keys
returned in JSON content from github API (#63)
* Fix to `update()` to work correctly for deleting files. didn't previously
set `null`'s correctly (#64)

gistr 0.3.4
===============

### NEW FEATURES

* Gained new function `gist_create_git()` - creates gists using `git` 
instead of the GitHub Gists HTTP API. Uses the package `git2r` 
internally to do the `git` things. (#50) This function has been 
around a while, but not in the CRAN version, so a few other fixes
of note in case you're interested: (#56) (#57) (#58) (#59) (#61)

### MINOR IMPROVEMENTS

* Added new manual file `?create_gists` with details of the three different
ways to create gists, how they differ, and why there are three different
functions to create a gist. (57f13a711fb7a1514caee6a858d4cda31d614e6f)

### BUG FIXES

* Fix to `tabl()` to give back cleaner data output, returning main
metadata for each gist in a single data.frame, then forks and 
history in separate data.frame's if they exist. Makes for easier 
understanding and manipulation downstream. (#54)

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
