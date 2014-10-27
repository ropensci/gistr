context("gist_create")

test_that("gist_create works from a file", {
  file <- system.file("examples", "stuff.Rmd", package = "gistr")
  g <- gist_create(file, browse = FALSE)
  expect_is(g, "gist")
  expect_equal(names(g$files), "stuff.Rmd")
  expect_true(g$public)
  expect_identical(g$forks, list())
  
  # cleanup
  suppressMessages(g %>% delete())
})

test_that("gist_create works from a code block", {
  h <- gist_create(code={'
  x <- letters
  (numbers <- runif(8))
  '}, filename="my_cool_code.R", browse=FALSE)
  
  expect_is(h, "gist")
  expect_equal(names(h$files), "my_cool_code.R")
  expect_true(h$public)
  expect_identical(h$forks, list())
  
  # cleanup
  suppressMessages(h %>% delete())
})
