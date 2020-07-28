gistr
=======



[![cran checks](https://cranchecks.info/badges/worst/gistr)](https://cranchecks.info/pkgs/gistr)
[![Build Status](https://api.travis-ci.org/ropensci/gistr.png)](https://travis-ci.org/ropensci/gistr)
[![Build status](https://ci.appveyor.com/api/projects/status/4jmuxbbv8qg4139t/branch/master?svg=true)](https://ci.appveyor.com/project/sckott/gistr/branch/master)
[![codecov.io](https://codecov.io/github/ropensci/gistr/coverage.svg?branch=master)](https://codecov.io/github/ropensci/gistr?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/gistr)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/gistr)](https://cran.r-project.org/package=gistr)

`gistr` is a light interface to GitHub's gists for R.

## See also:

* [rgithub](https://github.com/cscheid/rgithub) an R client for the Github API by Carlos Scheidegger
* [git2r](https://github.com/ropensci/git2r) an R client for the libgit2 C library by Stefan Widgren
* [gert](https://github.com/r-lib/gert) Simple git client for R by Jeroen Ooms
* [gistfo](https://github.com/MilesMcBain/gistfo) for turning your untitled RStudio tabs into gists!

## Quick start

### Install

Stable version from CRAN


```r
install.packages("gistr")
```

Or dev version from GitHub.


```r
devtools::install_github("ropensci/gistr")
```


```r
library("gistr")
```

### Authentication

There are two ways to authorise gistr to work with your GitHub account:

* Generate a personal access token (PAT) **with the gist scope selected** at [https://help.github.com/articles/creating-an-access-token-for-command-line-use](https://help.github.com/articles/creating-an-access-token-for-command-line-use) and record it in the `GITHUB_PAT` environment variable.
  - To test out this approach, execute this in R: `Sys.setenv(GITHUB_PAT = "blahblahblah")`, where "blahblahblah" is the PAT you got from GitHub. Then take `gistr` out for a test drive.
  - If that works, you will probably want to define the GITHUB_PAT environment variable in a file such as `~/.bash_profile` or `~/.Renviron`.
* Interactively login into your GitHub account and authorise with OAuth.

Using the PAT is recommended.

Using the `gist_auth()` function you can authenticate separately first, or if you're not authenticated, this function will run internally with each function call. If you have a PAT, that will be used, if not, OAuth will be used.


```r
gist_auth()
```

### Workflow

In `gistr` you can use pipes, introduced perhaps first in R in the package `magrittr`, to pass outputs from one function to another. If you have used `dplyr` with pipes you can see the difference, and perhaps the utility, of this workflow over the traditional workflow in R. You can use a non-piping or a piping workflow with `gistr`. Examples below use a mix of both workflows. Here is an example of a piping workflow (with some explanation):


```r
file <- system.file("examples", "alm.md", package = "gistr")
gists(what = "minepublic")[[1]] %>% # List my public gists, and index to get just the 1st one
  add_files(file) %>% # Add a new file to that gist
  update() # update sends a PATCH command to the Gists API to add the file to your gist online
```

And a non-piping workflow that does the same exact thing:


```r
file <- system.file("examples", "alm.md", package = "gistr")
g <- gists(what = "minepublic")[[1]]
g <- add_files(g, file)
update(g)
```

Or you could string them all together in one line (but it's rather difficult to follow what's going on because you have to read from the inside out)


```r
file <- system.file("examples", "alm.md", package = "gistr")
update(add_files(gists(what = "minepublic")[[1]], file))
```

### Rate limit information


```r
rate_limit()
#> Rate limit: 5000
#> Remaining:  4999
#> Resets in:  60 minutes
```

### List gists

Limiting to a few results here to keep it brief


```r
gists(per_page = 2)
#> [[1]]
#> <gist>04b88f61e1e6c457354958c1e47c9bea
#>   URL: https://gist.github.com/04b88f61e1e6c457354958c1e47c9bea
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:02:08Z / 2020-01-09T18:02:09Z
#>   Files: maestra.blade.php
#>   Truncated?: FALSE
#> 
#> [[2]]
#> <gist>137ec8aa8c62a44d6b25afe94c1572ce
#>   URL: https://gist.github.com/137ec8aa8c62a44d6b25afe94c1572ce
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:01:41Z / 2020-01-09T18:01:42Z
#>   Files: CalciteLib.java
#>   Truncated?: FALSE
```

Since a certain date/time


```r
gists(since='2014-05-26T00:00:00Z', per_page = 2)
#> [[1]]
#> <gist>04b88f61e1e6c457354958c1e47c9bea
#>   URL: https://gist.github.com/04b88f61e1e6c457354958c1e47c9bea
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:02:08Z / 2020-01-09T18:02:09Z
#>   Files: maestra.blade.php
#>   Truncated?: FALSE
#> 
#> [[2]]
#> <gist>137ec8aa8c62a44d6b25afe94c1572ce
#>   URL: https://gist.github.com/137ec8aa8c62a44d6b25afe94c1572ce
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:01:41Z / 2020-01-09T18:01:42Z
#>   Files: CalciteLib.java
#>   Truncated?: FALSE
```

Request different types of gists, one of public, minepublic, mineall, or starred.


```r
gists('minepublic', per_page = 2)
#> [[1]]
#> <gist>fc231d025d54c1a1cb3d37f9790b9166
#>   URL: https://gist.github.com/fc231d025d54c1a1cb3d37f9790b9166
#>   Description: gist gist gist
#>   Public: TRUE
#>   Created/Edited: 2020-01-08T17:39:13Z / 2020-01-08T17:39:15Z
#>   Files: stuff.md, zoo.json
#>   Truncated?: FALSE, FALSE
#> 
#> [[2]]
#> <gist>1f5ab3d71680e0d014ead0e8f2cc5b26
#>   URL: https://gist.github.com/1f5ab3d71680e0d014ead0e8f2cc5b26
#>   Description: gist gist gist
#>   Public: TRUE
#>   Created/Edited: 2020-01-08T17:38:24Z / 2020-01-08T17:38:25Z
#>   Files: stuff.md, zoo.json
#>   Truncated?: FALSE, FALSE
```


### List a single commit


```r
gist(id = 'f1403260eb92f5dfa7e1')
#> <gist>f1403260eb92f5dfa7e1
#>   URL: https://gist.github.com/f1403260eb92f5dfa7e1
#>   Description: Querying bitly from R 
#>   Public: TRUE
#>   Created/Edited: 2014-10-15T20:40:12Z / 2015-08-29T14:07:43Z
#>   Files: bitly_r.md
#>   Truncated?: FALSE
```

### Create gist

You can pass in files


```r
file <- system.file("examples", "stuff.md", package = "gistr")
gist_create(file, description='a new cool gist', browse = FALSE)
#> <gist>c0e374bc494c17cf0cd6bacc3e3ac146
#>   URL: https://gist.github.com/c0e374bc494c17cf0cd6bacc3e3ac146
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:02:40Z / 2020-01-09T18:02:40Z
#>   Files: stuff.md
#>   Truncated?: FALSE
```

Or, wrap `gist_create()` around some code in your R session/IDE, with just the function name, and a `{'` at the start and a `}'` at the end.


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
#> <gist>1af2ae5eeccb9fe88391952253f4b9ed
#>   URL: https://gist.github.com/1af2ae5eeccb9fe88391952253f4b9ed
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:02:43Z / 2020-01-09T18:02:43Z
#>   Files: code.R
#>   Truncated?: FALSE
```

#### knit and create

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

Or code blocks before (note that code blocks without knitr block demarcations will result in unexecuted code):


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

### knit code from file path, code block, or gist file

knit a local file


```r
file <- system.file("examples", "stuff.Rmd", package = "gistr")
run(file, knitopts = list(quiet=TRUE)) %>% gist_create(browse = FALSE)
#> <gist>697796181d98bd0483301171f85f335e
#>   URL: https://gist.github.com/697796181d98bd0483301171f85f335e
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:02:44Z / 2020-01-09T18:02:44Z
#>   Files: stuff.md
#>   Truncated?: FALSE
```



knit a code block (knitr code block notation missing, do add that in) (result not shown)


```r
run({'
x <- letters
(numbers <- runif(8))
'}) %>% gist_create
```

knit a file from a gist, has to get file first (result not shown)


```r
gists('minepublic')[[1]] %>% run() %>% update()
```

### working with images

The GitHub API doesn't let you upload binary files (e.g., images) via their HTTP API, which we use in `gistr`. There is a workaround.

If you are using `.Rmd` or `.Rnw` files, you can set `imgur_inject = TRUE` in `gistr_create()` so that imgur knit options are injected at the top of your file so that images will be uploaded to imgur. Alternatively, you can do this yourself, setting knit options to use imgur.

A file already using imgur


```r
file <- system.file("examples", "plots_imgur.Rmd", package = "gistr")
gist_create(file, knit=TRUE)
#> <gist>1a6e7f7d6ddb739fce0b
#>   URL: https://gist.github.com/1a6e7f7d6ddb739fce0b
#>   Description:
#>   Public: TRUE
#>   Created/Edited: 2015-03-19T00:20:48Z / 2015-03-19T00:20:48Z
#>   Files: plots_imgur.md
```

A file _NOT_ already using imgur


```r
file <- system.file("examples", "plots.Rmd", package = "gistr")
gist_create(file, knit=TRUE, imgur_inject = TRUE)
#> <gist>ec9987ad245bbc668c72
#>   URL: https://gist.github.com/ec9987ad245bbc668c72
#>   Description:
#>   Public: TRUE
#>   Created/Edited: 2015-03-19T00:21:13Z / 2015-03-19T00:21:13Z
#>   Files: plots.md
```

### List commits on a gist


```r
gists()[[1]] %>% commits()
#> [[1]]
#> <commit>
#>   Version: 120981f13c1406f61f213775ce3677a23a7151e2
#>   User: sckott
#>   Commited: 2020-01-09T18:02:42Z
#>   Commits [total, additions, deletions]: [5,5,0]
```

### Star a gist

Star


```r
gist('cbb0507082bb18ff7e4b') %>% star()
#> <gist>cbb0507082bb18ff7e4b
#>   URL: https://gist.github.com/cbb0507082bb18ff7e4b
#>   Description: This is my technical interview cheat sheet.  Feel free to fork it or do whatever you want with it.  PLEASE let me know if there are any errors or if anything crucial is missing.  I will add more links soon.
#>   Public: TRUE
#>   Created/Edited: 2014-05-02T19:43:13Z / 2018-04-16T21:11:53Z
#>   Files: The Technical Interview Cheat Sheet.md
#>   Truncated?: FALSE
```

Unstar


```r
gist('cbb0507082bb18ff7e4b') %>% unstar()
#> <gist>cbb0507082bb18ff7e4b
#>   URL: https://gist.github.com/cbb0507082bb18ff7e4b
#>   Description: This is my technical interview cheat sheet.  Feel free to fork it or do whatever you want with it.  PLEASE let me know if there are any errors or if anything crucial is missing.  I will add more links soon.
#>   Public: TRUE
#>   Created/Edited: 2014-05-02T19:43:13Z / 2018-04-16T21:27:36Z
#>   Files: The Technical Interview Cheat Sheet.md
#>   Truncated?: FALSE
```

### Edit a gist

Add files


```r
file <- system.file("examples", "alm.md", package = "gistr")
gists(what = "minepublic")[[1]] %>%
  add_files(file) %>%
  update()
#> <gist>1af2ae5eeccb9fe88391952253f4b9ed
#>   URL: https://gist.github.com/1af2ae5eeccb9fe88391952253f4b9ed
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:02:43Z / 2020-01-09T18:02:50Z
#>   Files: alm.md, code.R
#>   Truncated?: FALSE, FALSE
```

Delete files


```r
file <- system.file("examples", "alm.md", package = "gistr")
gists(what = "minepublic")[[1]] %>%
  delete_files(file) %>%
  update()
#> <gist>1af2ae5eeccb9fe88391952253f4b9ed
#>   URL: https://gist.github.com/1af2ae5eeccb9fe88391952253f4b9ed
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:02:43Z / 2020-01-09T18:02:52Z
#>   Files: code.R
#>   Truncated?: FALSE
```

### Open a gist in your default browser


```r
gists()[[1]] %>% browse()
```

> Opens the gist in your default browser

### Get embed script


```r
gists()[[1]] %>% embed()
#> [1] "<script src=\"https://gist.github.com/sckott/1af2ae5eeccb9fe88391952253f4b9ed.js\"></script>"
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
#>   Created/Edited: 2012-01-19T21:45:20Z / 2019-10-23T20:09:07Z
#>   Files: 
#>   Truncated?: 
#> 
#> [[2]]
#> <gist>1643051
#>   URL: https://gist.github.com/1643051
#>   Description: Line Transition (Broken)
#>   Public: TRUE
#>   Created/Edited: 2012-01-19T21:51:30Z / 2019-10-23T20:08:44Z
#>   Files: 
#>   Truncated?:
```

### Fork a gist

Returns a `gist` object


```r
g <- gists()
(forked <- g[[ sample(seq_along(g), 1) ]] %>% fork())
#> <gist>93c7894c4eb5b0b9fcfaa1d223d6b46e
#>   URL: https://gist.github.com/93c7894c4eb5b0b9fcfaa1d223d6b46e
#>   Description: fsadfds
#>   Public: TRUE
#>   Created/Edited: 2020-01-09T18:03:00Z / 2020-01-09T18:03:00Z
#>   Files: fsdfas
#>   Truncated?: FALSE
```


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/gistr/issues).
* License: MIT
* Get citation information for `gistr` in R doing `citation(package = 'gistr')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/gistr/blob/master/CODE_OF_CONDUCT.md
