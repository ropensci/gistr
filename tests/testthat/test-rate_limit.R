# tests for rate_limit function
context("rate_limit")

test_that("rate_limit works", {
  expect_is(rate_limit(), "gist_rate")
})
