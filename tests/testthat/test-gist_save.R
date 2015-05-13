context("gist_save")

test_that("gist_save works", {
  aa <- gist("a65ac7e56b7b3f746913") %>% gist_save()
  expect_is(aa, "character")
  expect_is(aa[[1]], "character")
})
