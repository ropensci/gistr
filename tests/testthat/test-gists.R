# tests for listing gists
context("gists")

test_that("listing gists works", {
  skip_on_cran()
  
  expect_is(gists()[[1]], "gist")
  expect_equal(length(gists(per_page=2)), 2)
})

test_that("curl options work", {
  skip_on_cran()
  
  expect_error(gists(timeout_ms = 1))
})
