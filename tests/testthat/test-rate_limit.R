# tests for rate_limit function
context("rate_limit")

test_that("rate_limit works", {
  expect_is(rate_limit(), "gist_rate")
})

test_that("config options work", {
  library('httr')
  expect_error(rate_limit(config=timeout(0.001)))
})
