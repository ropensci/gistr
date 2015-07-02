# tests for delete
context("delete")

f <- system.file("examples", "stuff.md", package = "gistr")

test_that("delete returns NULL", {
  skip_on_cran()
  
  # crate a new gist first, then delete
  g <- gist_create(f, "gist gist gist", TRUE, browse = FALSE)
  del <- suppressMessages(g %>% delete())
  
  expect_null(del)
})

test_that("delete returns correct message", {
  skip_on_cran()
  
  h <- gist_create(f, "gist gist gist", TRUE, browse = FALSE)
  expect_message(h %>% delete(), "Your gist has been deleted")
})
