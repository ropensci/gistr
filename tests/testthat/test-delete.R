# tests for delete
context("delete")

test_that("delete returns NULL", {
  # crate a new gist first, then delete
  f <- system.file("examples", "stuff.md", package = "gistr")
  g <- gist_create(f, "gist gist gist", TRUE, browse = FALSE)
  del <- g %>% delete()
  
  expect_null(del)
})

test_that("delete returns correct message", {
  h <- gist_create(f, "gist gist gist", TRUE, browse = FALSE)
  expect_message(h %>% delete(), "Your gist has been deleted")
})
