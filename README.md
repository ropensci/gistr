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
devtools::install_github("ropensci/gistr")
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

### List gists

Limiting to a few results here to keep it brief


```r
gists(per_page = 2)
#> [[1]]
#> <gist>7cc8d1295e1d2b298c68
#>   URL: https://gist.github.com/7cc8d1295e1d2b298c68
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:30:47Z / 2014-10-17T21:30:48Z
#>   Files: gistfile1.rb
#> 
#> [[2]]
#> <gist>8191f8a6b1113d80b8dd
#>   URL: https://gist.github.com/8191f8a6b1113d80b8dd
#>   Description: Illustration of how to use the R sp, raster, and ncdf packages to output GCAM data in netCDF format
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:30:36Z / 2014-10-17T21:30:37Z
#>   Files: gcam2nc.R
```

Since a certain date/time


```r
gists(since='2014-05-26T00:00:00Z', per_page = 2)
#> [[1]]
#> <gist>7cc8d1295e1d2b298c68
#>   URL: https://gist.github.com/7cc8d1295e1d2b298c68
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:30:47Z / 2014-10-17T21:30:48Z
#>   Files: gistfile1.rb
#> 
#> [[2]]
#> <gist>8191f8a6b1113d80b8dd
#>   URL: https://gist.github.com/8191f8a6b1113d80b8dd
#>   Description: Illustration of how to use the R sp, raster, and ncdf packages to output GCAM data in netCDF format
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:30:36Z / 2014-10-17T21:30:37Z
#>   Files: gcam2nc.R
```

Request different types of gists, one of public, minepublic, mineall, or starred.


```r
gists('minepublic', per_page = 2)
#> [[1]]
#> <gist>ee18bf2920194d63d74a
#>   URL: https://gist.github.com/ee18bf2920194d63d74a
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:02:44Z / 2014-10-17T21:30:08Z
#>   Files: stuff.md
#> 
#> [[2]]
#> <gist>38dbc3b4900b8aba2a43
#>   URL: https://gist.github.com/38dbc3b4900b8aba2a43
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:01:31Z / 2014-10-17T21:01:31Z
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


```r
gist_create(files="~/stuff.md", description='a new cool gist')
#> <gist>bfa698a2ca0314936af7
#>   URL: https://gist.github.com/bfa698a2ca0314936af7
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:31:42Z / 2014-10-17T21:31:42Z
#>   Files: stuff.md
```

### List commits on a gist


```r
gists()[[1]] %>% commits()
#> [[1]]
#> <commit>
#>   Version: f485d42a142f9cd83215048697376966d5e1ae0a
#>   Commited: 2014-10-17T21:31:42Z
#>   Commits [total, additions, deletions]: [19,19,0]
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
#> <gist>bfa698a2ca0314936af7
#>   URL: https://gist.github.com/bfa698a2ca0314936af7
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:31:42Z / 2014-10-17T21:31:44Z
#>   Files: alm_othersources.md, stuff.md
```

Delete files


```r
gists(what = "minepublic")[[1]] %>%
  delete_files("~/alm_othersources.md") %>%
  edit()
#> <gist>bfa698a2ca0314936af7
#>   URL: https://gist.github.com/bfa698a2ca0314936af7
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-17T21:31:42Z / 2014-10-17T21:31:44Z
#>   Files: stuff.md
```

### Open a gist in your default browser


```r
gists()[[1]] %>% browse()
```

> Opens the gist in your default browser

### Get embed script


```r
gists()[[1]] %>% embed()
#> [1] "<script src=\"https://gist.github.com/sckott/bfa698a2ca0314936af7.js\"></script>"
```


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/gistr/issues).
* License: MIT
* Get citation information for `gistr` in R doing `citation(package = 'gistr')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
