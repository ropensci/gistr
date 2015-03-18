### Install and load alm


```r
install_github("ropensci/alm")
```


```r
library("alm")
```

### PLOS article data

The default in the `alm` package is for the PLOS ALM app. You do need to get an API key first here [http://alm.plos.org/](http://alm.plos.org/). You can pass in the `key` parameter or store in your `.Rprofile` file and pass in that way, or do `options(PlosApiKey = "yourkey")` and that will be stored for your current R session.


```r
alm_ids(doi='10.1371/journal.pone.0036240')
```

```
## $meta
##   total total_pages page error
## 1     1           1    1    NA
## 
## $data
##                       .id  pdf  html readers comments likes total
## 1               citeulike   NA    NA       5       NA    NA     5
## 2                crossref   NA    NA      NA       NA    NA     5
## 3                  nature   NA    NA      NA       NA    NA     1
## 4                  pubmed   NA    NA      NA       NA    NA     5
## 5                  scopus   NA    NA      NA       NA    NA     8
## 6                 counter 1152 16122      NA       NA    NA 17321
## 7        researchblogging   NA    NA      NA       NA    NA     1
## 8                     wos   NA    NA      NA       NA    NA     6
## 9                     pmc   64   194      NA       NA    NA   258
## 10               facebook   NA    NA      72       57    56   185
## 11               mendeley   NA    NA      70       NA    NA    70
## 12                twitter   NA    NA      NA      161    NA   161
## 13              wikipedia   NA    NA      NA       NA    NA     0
## 14          scienceseeker   NA    NA      NA       NA    NA     0
## 15         relativemetric   NA    NA      NA       NA    NA 43647
## 16                  f1000   NA    NA      NA       NA    NA     0
## 17               figshare    0     0      NA       NA     0     0
## 18              pmceurope   NA    NA      NA       NA    NA     5
## 19          pmceuropedata   NA    NA      NA       NA    NA     0
## 20            openedition   NA    NA      NA       NA    NA     0
## 21              wordpress   NA    NA      NA       NA    NA     0
## 22                 reddit   NA    NA      NA        0     0     0
## 23               datacite   NA    NA      NA       NA    NA     0
## 24             copernicus   NA    NA      NA       NA    NA     0
## 25        articlecoverage   NA    NA      NA        0    NA     0
## 26 articlecoveragecurated   NA    NA      NA        0    NA     0
## 27          plos_comments   NA    NA      NA        3    NA     4
```

### Crossref article data

You need to get a Crossref ALM API key first here [http://alm.labs.crossref.org/docs/Home](http://alm.labs.crossref.org/docs/Home), and pass in a different URL


```r
url <- "http://alm.labs.crossref.org/api/v5/articles"
alm_ids(doi='10.1371/journal.pone.0086859', url = url, key = getOption("crossrefalmkey"))
```

```
## $meta
##   total total_pages page error
## 1     1           1    1    NA
## 
## $data
##              .id pdf html readers comments likes total
## 1       crossref  NA   NA      NA       NA    NA     0
## 2       mendeley  NA   NA      NA       NA    NA     0
## 3       facebook  NA   NA      NA       NA    NA     0
## 4            pmc  NA   NA      NA       NA    NA     0
## 5      citeulike  NA   NA      NA       NA    NA     0
## 6         pubmed  NA   NA      NA       NA    NA     0
## 7      wordpress  NA   NA      NA       NA    NA     0
## 8         reddit  NA   NA      NA       NA    NA     0
## 9      wikipedia  NA   NA      NA       NA    NA     2
## 10      datacite  NA   NA      NA       NA    NA     0
## 11     pmceurope  NA   NA      NA       NA    NA     0
## 12 pmceuropedata  NA   NA      NA       NA    NA     0
```

### Public Knowledge Project (PKP) article data

You need to get a PKP ALM API key first here [http://pkp-alm.lib.sfu.ca/](http://pkp-alm.lib.sfu.ca/), and pass in a different URL


```r
url <- 'http://pkp-alm.lib.sfu.ca/api/v5/articles'
alm_ids(doi='10.3402/gha.v7.23554', url = url, key = getOption("pkpalmkey"))
```

```
## $meta
##   total total_pages page error
## 1     1           1    1    NA
## 
## $data
##                 .id pdf html readers comments likes total
## 1         citeulike  NA   NA       0       NA    NA     0
## 2            pubmed  NA   NA      NA       NA    NA     0
## 3         wikipedia  NA   NA      NA       NA    NA     0
## 4          mendeley  NA   NA       1       NA    NA     1
## 5          facebook  NA   NA       3        0     0     3
## 6            nature  NA   NA      NA       NA    NA     0
## 7  researchblogging  NA   NA      NA       NA    NA     0
## 8          crossref  NA   NA      NA       NA    NA     0
## 9     scienceseeker  NA   NA      NA       NA    NA     0
## 10        pmceurope  NA   NA      NA       NA    NA     0
## 11    pmceuropedata  NA   NA      NA       NA    NA     0
## 12      openedition  NA   NA      NA       NA    NA     0
## 13        wordpress  NA   NA      NA       NA    NA     0
## 14           reddit  NA   NA      NA       NA    NA     0
## 15       copernicus  NA   NA      NA       NA    NA     0
## 16           scopus  NA   NA      NA       NA    NA     0
## 17              pmc  NA   NA      NA       NA    NA     0
## 18   twitter_search  NA   NA      NA        0    NA     0
## 19            f1000  NA   NA      NA       NA    NA     0
```

<br>
__el fin!__
