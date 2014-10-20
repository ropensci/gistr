# tests for edit
context("edit")

test_that("edit xxxx", {
  # crate a new gist first, then edit it
  stuff <- system.file("examples", "stuff.md", package = "gistr")
  g <- gist_create(stuff, "gist gist gist", TRUE, browse = FALSE)
  expect_equal(names(g$files), "stuff.md")
  
  zoo <- system.file("examples", "zoo.json", package = "gistr")
  ed <- g %>% add_files(zoo) %>% edit()
  expect_equal(names(ed$files), c("stuff.md","zoo.json"))
})
