# tests for update
context("update")

test_that("update works", {
  skip_on_cran()
  
  # crate a new gist first, then update it
  stuff <- system.file("examples", "stuff.md", package = "gistr")
  g <- gist_create(stuff, "gist gist gist", TRUE, browse = FALSE)
  expect_equal(names(g$files), "stuff.md")
  
  zoo <- system.file("examples", "zoo.json", package = "gistr")
  ed <- g %>% add_files(zoo) %>% update()
  expect_equal(names(ed$files), c("stuff.md","zoo.json"))
})
