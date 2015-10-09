context("gist_create_git")

test_that("gist_create_git works xxx", {
  skip_on_cran()
  
  unlink("~/gitgist", recursive = TRUE)
  dir.create("~/gitgist")
  file <- system.file("examples", "stuff.md", package = "gistr")
  writeLines(readLines(file), con = file.path("~/gitgist", "stuff.md"))

  aa <- gist_create_git(files = file.path("~/gitgist", "stuff.md"), browse = FALSE)
  
  expect_is(aa, "gist")
  expect_named(aa$files, "stuff.md")
  expect_is(aa$files$stuff.md$content, "character")
  expect_true(aa$public)
  
  # cleanup
  invisible(suppressMessages(lapply(list(aa), delete)))
})

test_that("gist_create_git fails well", {
  skip_on_cran()

  expect_error(gist_create_git(), "invalid 'file' argument")
  expect_error(gist_create_git("tttttt"), "'tttttt' does not exist")
})
