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



### Rate limit information


```r
rate_limit()
#> Rate limit: 5000
#> Remaining:  4999
#> Resets in:  59 minutes
```


### List gists

Limiting to a few results here to keep it brief


```r
gists(per_page = 2)
#> [[1]]
#> <gist>fe45fded4eba7eece6e0
#>   URL: https://gist.github.com/fe45fded4eba7eece6e0
#>   Description: HMH_rail_step_4
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T23:00:18Z / 2014-10-20T23:00:19Z
#>   Files: HMH_rail_step_4
#> 
#> [[2]]
#> <gist>5158836d024d23f683d5
#>   URL: https://gist.github.com/5158836d024d23f683d5
#>   Description: HMH_rail_step_3
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T22:59:40Z / 2014-10-20T22:59:41Z
#>   Files: HMH_rail_step_3
```

Since a certain date/time


```r
gists(since='2014-05-26T00:00:00Z', per_page = 2)
#> [[1]]
#> <gist>fe45fded4eba7eece6e0
#>   URL: https://gist.github.com/fe45fded4eba7eece6e0
#>   Description: HMH_rail_step_4
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T23:00:18Z / 2014-10-20T23:00:19Z
#>   Files: HMH_rail_step_4
#> 
#> [[2]]
#> <gist>5158836d024d23f683d5
#>   URL: https://gist.github.com/5158836d024d23f683d5
#>   Description: HMH_rail_step_3
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T22:59:40Z / 2014-10-20T22:59:41Z
#>   Files: HMH_rail_step_3
```

Request different types of gists, one of public, minepublic, mineall, or starred.


```r
gists('minepublic', per_page = 2)
#> [[1]]
#> <gist>39acc03034ca2f5c086f
#>   URL: https://gist.github.com/39acc03034ca2f5c086f
#>   Description: gist gist gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T22:19:27Z / 2014-10-20T22:19:27Z
#>   Files: stuff.md
#> 
#> [[2]]
#> <gist>bbfc6f14e1a980af9b65
#>   URL: https://gist.github.com/bbfc6f14e1a980af9b65
#>   Description: gist gist gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T22:11:37Z / 2014-10-20T22:11:37Z
#>   Files: stuff.md
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
#> <gist>eff5be03f99c3563aa97
#>   URL: https://gist.github.com/eff5be03f99c3563aa97
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T23:00:57Z / 2014-10-20T23:00:57Z
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
#> <gist>faaa25e2d1bba1fccef4
#>   URL: https://gist.github.com/faaa25e2d1bba1fccef4
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T23:00:57Z / 2014-10-20T23:00:57Z
#>   Files: code.R
```


### List commits on a gist


```r
gists()[[1]] %>% commits()
#> [[1]]
#> <commit>
#>   Version: f1e4fccf7ceebe5604131210f4e24e013ea77a57
#>   User: sckott
#>   Commited: 2014-10-20T23:00:57Z
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
#> <gist>faaa25e2d1bba1fccef4
#>   URL: https://gist.github.com/faaa25e2d1bba1fccef4
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T23:00:57Z / 2014-10-20T23:00:59Z
#>   Files: alm_othersources.md, code.R
```

Delete files


```r
gists(what = "minepublic")[[1]] %>%
  delete_files("~/alm_othersources.md") %>%
  edit()
#> <gist>faaa25e2d1bba1fccef4
#>   URL: https://gist.github.com/faaa25e2d1bba1fccef4
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T23:00:57Z / 2014-10-20T23:00:59Z
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
#> [1] "<script src=\"https://gist.github.com/sckott/faaa25e2d1bba1fccef4.js\"></script>"
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
#> <gist>3c2b3b05af9592bc8dd0
#>   URL: https://gist.github.com/3c2b3b05af9592bc8dd0
#>   Description: Installer 1
#>   Public: TRUE
#>   Created/Edited: 2014-10-20T23:01:01Z / 2014-10-20T23:01:01Z
#>   Files: gistfile1.txt
```




## Meta

* Please [report any issues or bugs](https://github.com/ropensci/gistr/issues).
* License: MIT
* Get citation information for `gistr` in R doing `citation(package = 'gistr')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
