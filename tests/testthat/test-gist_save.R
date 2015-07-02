context("gist_save")

test_that("gist_save works", {
  skip_on_cran()
  
  dir <- tempdir()
  aa <- gist("a65ac7e56b7b3f746913") %>% gist_save(dir)
  expect_is(aa, "gist_files")
  expect_is(aa[[1]], "character")
  
  # cleanup
  unlink(dir, recursive = TRUE, force = TRUE)
})
