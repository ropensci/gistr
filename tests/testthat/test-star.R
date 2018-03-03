context("star")

test_that("star works", {
  skip_on_cran()
  
  id <- gists()[[1]]$id
  expect_message(gist(id) %>% star(), "Success, gist starred!")
  expect_message(gist(id) %>% star_check(), "TRUE")
  expect_message(gist(id) %>% unstar(), "Success, gist unstarred!")
  expect_message(gist(id) %>% star_check(), "FALSE")
  expect_message(gist(id) %>% unstar() %>% star(), "Success, gist starred!")
  expect_message(gist(id) %>% star_check(), "TRUE")
  
  # cleanup
  suppressMessages(gist(id) %>% unstar())
})

test_that("star works", {
  skip_on_cran()
  
  file <- system.file("examples", "stuff.Rmd", package = "gistr")
  g <- gist_create(file, browse = FALSE)
  expect_is(g, "gist")
  expect_is(suppressMessages(g %>% star()), "gist")
  expect_is(suppressMessages(g %>% unstar()), "gist")
  expect_is(suppressMessages(g %>% star_check()), "gist")
  
  # cleanup
  suppressMessages(g %>% delete())
})

