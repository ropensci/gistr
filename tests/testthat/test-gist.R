# tests for gist function
context("gist")

test_that("gist works", {
  expect_is(gist(id = 'f1403260eb92f5dfa7e1'), "gist")
})

test_that("as.gist works", {
  expect_is(as.gist('f1403260eb92f5dfa7e1'), "gist")
  expect_is(as.gist(10), "gist")
  expect_is(as.gist(gist('f1403260eb92f5dfa7e1')), "gist")
})

test_that("config options work", {
  library('httr')
  expect_error(gist(10, config=timeout(0.1)))
})
