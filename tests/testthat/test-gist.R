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
  expect_error(gist(10, config = timeout(0.001)))
})

test_that("passing in a URL", {
  x <- "https://gist.github.com/expersso/4ac33b9c00751fddc7f8"
  gurl <- as.gist(x)
  gurl2 <- gist(x)
  expect_is(gurl, "gist")
  expect_is(gurl2, "gist")
  expect_equal(gurl, gurl2)
  
  expect_error(gist("httpb://stuff.com"), "Not Found")
  # fixme: maybe we should accept various forms, like this
  expect_error(gist("gist.github.com/expersso/4ac33b9c00751fddc7f8"), "Not Found")
  # no id at end of url
  expect_error(gist("https://gist.github.com/expersso"), "Not Found")
})
