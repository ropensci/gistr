RSCRIPT = Rscript --no-init-file

move:
	cp inst/vign/gistr.md vignettes/
	cp -rf inst/vign/img/* vignettes/img/

rmd2md:
	cd vignettes;\
	mv gistr.md gistr.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

check:
	${RSCRIPT} -e 'rcmdcheck::rcmdcheck(args = c("--as-cran"))'

test:
	${RSCRIPT} -e 'devtools::test()'

