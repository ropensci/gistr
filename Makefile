all: move rmd2md

move:
		cp inst/vign/gistr.md vignettes/
		cp -rf inst/vign/img/* vignettes/img/

rmd2md:
		cd vignettes;\
		mv gistr.md gistr.Rmd
