R CMD CHECK passed on my local OS X install with R 3.1.2 and
R development version, Ubuntu running on Travis-CI, and Win builder.

Most examples are wrapped in donttest because all call the GitHub 
gists web API. Users can easily run these examples though with, e.g.
devtools::run_examples(). Many examples will not run without user 
authenticated first, an additional reason for donttest.

Thanks! Scott Chamberlain
