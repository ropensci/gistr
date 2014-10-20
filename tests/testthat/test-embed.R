# tests for delete
context("delete")

test_that("delete returns correct string and is character", {
  expect_output(gists()[[1]] %>% embed(), "script src=")
  expect_is(gists()[[1]] %>% embed(), "character")
})
