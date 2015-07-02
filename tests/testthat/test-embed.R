# tests for embed
context("embed")

test_that("embed returns correct string and is character", {
  skip_on_cran()
  
  expect_output(gists()[[1]] %>% embed(), "script src=")
  expect_is(gists()[[1]] %>% embed(), "character")
})
