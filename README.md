gistr
=======



[![Build Status](https://api.travis-ci.org/ropensci/gistr.png)](https://travis-ci.org/ropensci/gistr)
[![Build status](https://ci.appveyor.com/api/projects/status/4jmuxbbv8qg4139t/branch/master?svg=true)](https://ci.appveyor.com/project/sckott/gistr/branch/master)

`gistr` is a light interface to GitHub's gists for R.

## Seealso:

* [rgithub](https://github.com/cscheid/rgithub) an R client for the Github API by Carlos Scheidegger
* [git2r](https://github.com/ropensci/git2r) an R client for the libgit2 C library by Stefan Widgren

## Quick start

### Install


```r
devtools::install_github("ropensci/gistr@dev")
```


```r
library("gistr")
```

### Authentication

There are two ways to authorise gistr to work with your GitHub account:

* Generate a personal access token (PAT) at [https://help.github.com/articles/creating-an-access-token-for-command-line-use]() and record it in the `GITHUB_PAT` envar. 
* Interactively login into your GitHub account and authorise with OAuth.

Using the PAT is recommended.

Using the `gist_auth()` function you can authenticate seperately first, or if you're not authenticated, this function will run internally with each functionn call. If you have a PAT, that will be used, if not, OAuth will be used.


```r
gist_auth()
```

### Workflow

In `gistr` you can use pipes, introduced perhaps first in R in the package `magrittr`, to pass outputs from one function to another. If you have used `dplyr` with pipes you can see the difference, and perhaps the utility, of this workflow over the traditional workflow in R. You can use a non-piping or a piping workflow with `gistr`. Examples below use a mix of both workflows. Here is an example of a piping wofklow (with some explanation):


```r
gists(what = "minepublic")[[1]] %>% # List my public gists, and index to get just the 1st one 
  add_files("~/alm_othersources.md") %>% # Add a new file to that gist
  edit() # Edit sends a PATCH command to the Gists API to add the file to your gist online
```

And a non-piping workflow that does the same exact thing:


```r
g <- gists(what = "minepublic")[[1]]
g <- add_files(g, "~/alm_othersources.md")
edit(g)
```

Or you could string them all together in one line (but it's rather difficult to follow what's going on because you have to read from the inside out)


```r
edit(add_files(gists(what = "minepublic")[[1]], "~/alm_othersources.md"))
```

### Rate limit information


```r
rate_limit()
#> Rate limit: 5000
#> Remaining:  4969
#> Resets in:  18 minutes
```


### List gists

Limiting to a few results here to keep it brief


```r
gists(per_page = 2)
#> [[1]]
#> <gist>6cbe3f815666c6ecb3b1
#>   URL: https://gist.github.com/6cbe3f815666c6ecb3b1
#>   Description: BMWM3ろ ＼ SEC15­.­ZZ­.­AM  ＼あBMWM3
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:33:57Z / 2014-10-28T14:33:58Z
#>   Files: gistfile1.txt
#> 
#> [[2]]
#> <gist>f73079e56cd7e1edb9fb
#>   URL: https://gist.github.com/f73079e56cd7e1edb9fb
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:33:53Z / 2014-10-28T14:33:54Z
#>   Files: MSTR API example
```

Since a certain date/time


```r
gists(since='2014-05-26T00:00:00Z', per_page = 2)
#> [[1]]
#> <gist>6cbe3f815666c6ecb3b1
#>   URL: https://gist.github.com/6cbe3f815666c6ecb3b1
#>   Description: BMWM3ろ ＼ SEC15­.­ZZ­.­AM  ＼あBMWM3
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:33:57Z / 2014-10-28T14:33:58Z
#>   Files: gistfile1.txt
#> 
#> [[2]]
#> <gist>f73079e56cd7e1edb9fb
#>   URL: https://gist.github.com/f73079e56cd7e1edb9fb
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:33:53Z / 2014-10-28T14:33:54Z
#>   Files: MSTR API example
```

Request different types of gists, one of public, minepublic, mineall, or starred.


```r
gists('minepublic', per_page = 2)
#> [[1]]
#> <gist>164f15006bbc8d670c43
#>   URL: https://gist.github.com/164f15006bbc8d670c43
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:32:36Z / 2014-10-28T14:32:36Z
#>   Files: pelias_test.geojson
#> 
#> [[2]]
#> <gist>323c2e7ae4e496892f90
#>   URL: https://gist.github.com/323c2e7ae4e496892f90
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:32:30Z / 2014-10-28T14:32:32Z
#>   Files: code.R
```


### List a single commit


```r
gist(id = 'f1403260eb92f5dfa7e1')
#> <gist>f1403260eb92f5dfa7e1
#>   URL: https://gist.github.com/f1403260eb92f5dfa7e1
#>   Description: Querying bitly from R 
#>   Public: TRUE
#>   Created/Edited: 2014-10-15T20:40:12Z / 2014-10-15T21:54:29Z
#>   Files: bitly_r.md
```

### Create gist

You can pass in files


```r
gist_create(files="~/stuff.md", description='a new cool gist')
```


```r
gist_create(files="~/stuff.md", description='a new cool gist', browse = FALSE)
#> <gist>f1035183ddd467706703
#>   URL: https://gist.github.com/f1035183ddd467706703
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:34:02Z / 2014-10-28T14:34:02Z
#>   Files: stuff.md
```

Or, wrap `gist_create()` around some code in your R session/IDE, like so, with just the function name, and a `{'` at the start and a `}'` at the end.


```r
gist_create(code={'
x <- letters
numbers <- runif(8)
numbers

[1] 0.3229318 0.5933054 0.7778408 0.3898947 0.1309717 0.7501378 0.3206379 0.3379005
'})
```


```r
gist_create(code={'
x <- letters
numbers <- runif(8)
numbers

[1] 0.3229318 0.5933054 0.7778408 0.3898947 0.1309717 0.7501378 0.3206379 0.3379005
'}, browse=FALSE)
#> <gist>7c23a6a5633e11d75a58
#>   URL: https://gist.github.com/7c23a6a5633e11d75a58
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:34:03Z / 2014-10-28T14:34:03Z
#>   Files: code.R
```

You can also knit an input file before posting as a gist:


```r
file <- system.file("examples", "stuff.Rmd", package = "gistr")
gist_create(file, description='a new cool gist', knit=TRUE)
#> <gist>4162b9c53479fbc298db
#>   URL: https://gist.github.com/4162b9c53479fbc298db
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-27T16:07:31Z / 2014-10-27T16:07:31Z
#>   Files: stuff.md
```

Or code blocks before (note that code blocks without knitr block demarcations will simply just end up with the unexecuted code):


```r
gist_create(code={'
x <- letters
(numbers <- runif(8))
'}, knit=TRUE)
#> <gist>ec45c396dee4aa492139
#>   URL: https://gist.github.com/ec45c396dee4aa492139
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-27T16:09:09Z / 2014-10-27T16:09:09Z
#>   Files: file81720d1ceff.md
```

### List commits on a gist


```r
gists()[[1]] %>% commits()
#> [[1]]
#> <commit>
#>   Version: 6e9677fdeaded46b53dbf60ef7fb3bcf7874721b
#>   User: sckott
#>   Commited: 2014-10-28T14:34:03Z
#>   Commits [total, additions, deletions]: [5,5,0]
```

### Star a gist

Star


```r
gist('7ddb9810fc99c84c65ec') %>% star()
#> <gist>7ddb9810fc99c84c65ec
#>   URL: https://gist.github.com/7ddb9810fc99c84c65ec
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-06-27T17:50:37Z / 2014-06-27T17:50:37Z
#>   Files: code.R, manifest.yml, rrt_manifest.yml
```

Unstar


```r
gist('7ddb9810fc99c84c65ec') %>% unstar()
#> <gist>7ddb9810fc99c84c65ec
#>   URL: https://gist.github.com/7ddb9810fc99c84c65ec
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-06-27T17:50:37Z / 2014-06-27T17:50:37Z
#>   Files: code.R, manifest.yml, rrt_manifest.yml
```

### Edit a gist

Add files


```r
gists(what = "minepublic")[[1]] %>%
  add_files("~/alm_othersources.md") %>%
  edit()
#> <gist>7c23a6a5633e11d75a58
#>   URL: https://gist.github.com/7c23a6a5633e11d75a58
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:34:03Z / 2014-10-28T14:34:05Z
#>   Files: alm_othersources.md, code.R
```

Delete files


```r
gists(what = "minepublic")[[1]] %>%
  delete_files("~/alm_othersources.md") %>%
  edit()
#> <gist>7c23a6a5633e11d75a58
#>   URL: https://gist.github.com/7c23a6a5633e11d75a58
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:34:03Z / 2014-10-28T14:34:06Z
#>   Files: code.R
```

### Open a gist in your default browser


```r
gists()[[1]] %>% browse()
```

> Opens the gist in your default browser

### Get embed script


```r
gists()[[1]] %>% embed()
#> [1] "<script src=\"https://gist.github.com/sckott/7c23a6a5633e11d75a58.js\"></script>"
```

### List forks

Returns a list of `gist` objects, just like `gists()`


```r
gist(id='1642874') %>% forks(per_page=2)
#> [[1]]
#> <gist>1642989
#>   URL: https://gist.github.com/1642989
#>   Description: Spline Transition
#>   Public: TRUE
#>   Created/Edited: 2012-01-19T21:45:20Z / 2014-09-09T02:22:03Z
#>   Files: 
#> 
#> [[2]]
#> <gist>1643051
#>   URL: https://gist.github.com/1643051
#>   Description: Line Transition (Broken)
#>   Public: TRUE
#>   Created/Edited: 2012-01-19T21:51:30Z / 2014-04-09T03:11:36Z
#>   Files:
```

### Fork a gist

Returns a `gist` object


```r
g <- gists()
(forked <- g[[ sample(seq_along(g), 1) ]] %>% fork())
#> <gist>829a03093b4d5173930c
#>   URL: https://gist.github.com/829a03093b4d5173930c
#>   Description: Gives the permutations
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:34:07Z / 2014-10-28T14:34:07Z
#>   Files: permute.lisp
```



## Example use case

_Working with the Mapzen Pelias geocoding API_

The API is described at https://github.com/pelias/pelias, and is still in alpha they say. The steps: get data, make a gist.


```r
library('httr')
base <- "http://pelias.mapzen.com/search"
res <- GET(base, query = list(input = 'coffee shop', lat = 45.5, lon = -122.6))
json <- content(res, as = "text")
gist_create(code = json, filename = "pelias_test.geojson")
#> <gist>e63488a7961490940f54
#>   URL: https://gist.github.com/e63488a7961490940f54
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:34:09Z / 2014-10-28T14:34:09Z
#>   Files: pelias_test.geojson
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/gistr/issues).
* License: MIT
* Get citation information for `gistr` in R doing `citation(package = 'gistr')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
