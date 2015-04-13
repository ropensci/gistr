context("gist_create")

test_that("gist_create works from a file", {
  file <- system.file("examples", "stuff.Rmd", package = "gistr")
  g <- gist_create(file, browse = FALSE, knitopts = list(quiet = TRUE))
  expect_is(g, "gist")
  expect_equal(names(g$files), "stuff.Rmd")
  expect_true(g$public)
  expect_identical(g$forks, list())
  
  # cleanup
  suppressMessages(g %>% delete())
})

test_that("gist_create works from a code block", {
  h <- gist_create(code = {'
  x <- letters
  (numbers <- runif(8))
  '}, filename = "my_cool_code.R", browse = FALSE, knitopts = list(quiet = TRUE))
  
  expect_is(h, "gist")
  expect_equal(names(h$files), "my_cool_code.R")
  expect_true(h$public)
  expect_identical(h$forks, list())
  
  # cleanup
  suppressMessages(h %>% delete())
})

test_that("gist_create works to upload images", {
  ## using imgur - if you're file uses imgur or similar, you're good
  file <- system.file("examples", "plots_imgur.Rmd", package = "gistr")
  res1 <- gist_create(file, knit = TRUE, browse = FALSE, knitopts = list(quiet = TRUE))
  
  ## inject imgur
  file <- system.file("examples", "plots.Rmd", package = "gistr")
  res2 <- gist_create(file, knit = TRUE, browse = FALSE, imgur_inject = TRUE, knitopts = list(quiet = TRUE))
  
  expect_is(res1, "gist")
  expect_equal(names(res1$files), "plots_imgur.md")
  expect_true(res1$public)
  
  # cleanup
  suppressMessages(res1 %>% delete())
  suppressMessages(res2 %>% delete())
})

test_that("gist_create fails correctly when binary files passed", {
  file <- system.file("examples", "file.png", package = "gistr")
  expect_error(gist_create(file, browse = FALSE), "Binary files not supported")
})

test_that("gist_create fails correctly when directory passed", {
  file <- system.file("examples", "file.png", package = "gistr")
  direct <- tempdir()
  expect_error(gist_create(direct, browse = FALSE), "Directories not supported")
  # binary check is first in the function
  expect_error(gist_create(c(direct, file), browse = FALSE), "Binary files not supported")
})

test_that("gist_create passes informative error messages correctly", {
  file <- system.file("examples", "file.png", package = "gistr")
  expect_error(gist_create(file, browse = FALSE), "Binary files not supported")
})
