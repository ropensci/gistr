# tests for gist function
context("gist")

test_that("gist works", {
  expect_is(gist(id = 'f1403260eb92f5dfa7e1'), "gist")
  expect_equal(length(gists(per_page=2)), 2)
})

test_that("config options work", {
  library('httr')
  expect_error(gists(config=timeout(0.1)))
})
