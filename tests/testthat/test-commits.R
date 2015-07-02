# tests for commits
context("commits")

test_that("commits works", {
  skip_on_cran()
  
  aa <- gists()[[1]] %>% commits()
  expect_is(aa, "list")
  expect_is(aa[[1]], "commit")
  
  bb <- gist(id='1f399774e9ecc9153a6f') %>% commits(per_page=2)
  expect_is(bb[[1]], "commit")
  expect_equal(length(bb), 2)
})

test_that("config options work", {
  skip_on_cran()
  
  library('httr')
  expect_equal( length(gists()[[1]] %>% commits(page = 454590788)), 0 )
})
