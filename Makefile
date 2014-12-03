all: move rmd2md

move:
		cp inst/vign/gistr_vignette.md vignettes/
		cp -rf inst/vign/img/* vignettes/img/

rmd2md:
		cd vignettes;\
		mv gistr_vignette.md gistr_vignette.Rmd
