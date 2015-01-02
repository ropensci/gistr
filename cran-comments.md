I have read and agree to the the CRAN policies at 
http://cran.r-project.org/web/packages/policies.html

R CMD CHECK passed on my local OS X install with R 3.1.2 and
R development version, Ubuntu running on Travis-CI, and Win builder.

Most examples are wrapped in \dontrun because all funtions and
examples call the GitHub gists API. Many examples will not run 
without user being authenticated first, an additional reason 
for \dontrun.

A note on submission frequency: I submitted a number of package 
updates recently, in December, 2014. However, these were almost 
all fix requests from CRAN maintainers.

A note about terminology. "star" is the term used by GitHub to 
indicate that a user on GitHub either likes the code repository, 
and wants to follow updates from that repository. "unstar" is 
when the user removes their star from that repository. I use
the same terminology in this package, but in the package
DESCRIPTION file in the Description section I use "un-star" 
to avoid words that don't exist in the standard dictionary.

Thanks! Scott Chamberlain
