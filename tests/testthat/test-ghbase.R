context("test-ghbase.R")

test_that("ghbase works", {
  
  github <- "https://api.github.com"
  acme <- "https://github.acme.com/api/v3"
  
  expect_identical(ghbase(), github)
  expect_identical(ghbase(acme), acme)
  
})

test_that("ghbase errors correctly", {
  
  expect_error(ghbase("github.acme.com"), "not a URL")
  
})
