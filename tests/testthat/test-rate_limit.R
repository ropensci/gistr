# tests for rate_limit function
context("rate_limit")

test_that("rate_limit works", {
  skip_on_cran()
  
  expect_is(rate_limit(), "gist_rate")
})
