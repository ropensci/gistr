gistr
=======

`gistr` is a light interface to GitHub's gists for R.

## Seealso:

* [rgithub](https://github.com/cscheid/rgithub) an R client for the Github API by Carlos Scheidegger
* [git2r](https://github.com/ropensci/git2r) an R client for the libgit2 C library by Stefan Widgren


## Quick start

### Install

```coffee
devtools::install_github("ropensci/gistr")
library("gistr")
```

### List commits

```coffee
gist_get(per_page=1)
```

```coffee
[[1]]
[[1]]$url
[1] "https://api.github.com/gists/d443c0e066f45530430a"

[[1]]$forks_url
[1] "https://api.github.com/gists/d443c0e066f45530430a/forks"

[[1]]$commits_url
[1] "https://api.github.com/gists/d443c0e066f45530430a/commits"

[[1]]$id
[1] "d443c0e066f45530430a"

[[1]]$git_pull_url
[1] "https://gist.github.com/d443c0e066f45530430a.git"
...cutoff
```

### Create gist

```coffee
gist_create(files="stuff.md", description='My gist!', public=TRUE)
```

```coffee
Your gist has been published
View gist at https://gist.github.com/sckott/5c1bde5c36984d808bf3
Embed gist with <script src="https://gist.github.com/sckott/5c1bde5c36984d808bf3.js"></script>
[1] "https://gist.github.com/sckott/5c1bde5c36984d808bf3"
```

### List commits on a gist

```coffee
gist_commits(id='cf5d2e572faafb4c6d5f', per_page=1)
```

```coffee
[[1]]
[[1]]$user
[[1]]$user$login
[1] "sckott"

[[1]]$user$id
[1] 577668

[[1]]$user$avatar_url
[1] "https://avatars.githubusercontent.com/u/577668?"
...cutoff
```


## Meta

Please report any issues or bugs](https://github.com/ropensci/gistr/issues).

License: MIT

This package is part of the [rOpenSci](http://ropensci.org/packages) project.

To cite package ‘gistr’ in publications use:

> Ramnath Vaidyanathan, Karthik Ram and Scott Chamberlain (2014). gistr: Work with gists from R.. R package version 0.0.2. https://github.com/ropensci/gistr

A BibTeX entry for LaTeX users is

```coffee
  @Manual{,
    title = {gistr: Work with gists from R.},
    author = {Ramnath Vaidyanathan and Karthik Ram and Scott Chamberlain},
    year = {2014},
    note = {R package version 0.0.2},
    url = {https://github.com/ropensci/gistr},
  }
```

Get citation information for `gistr` in R doing `citation(package = 'gistr')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
