context("gist_create_obj")

test_that("gist_create_obj works from a data.frame", {
  skip_on_cran()
  
  ## data.frame
  ### by default makes pretty table in markdown format
  row.names(mtcars) <- NULL
  df_1 <- gist_create_obj(mtcars, browse = FALSE)
  ### or just push up json
  df_3 <- gist_create_obj(mtcars, browse = FALSE, pretty = FALSE)
  
  expect_is(df_1, "gist")
  expect_named(df_1$files, "file.txt")
  expect_true(df_1$public)
  
  expect_is(df_3, "gist")
  expect_named(df_3$files, "file.txt")
  expect_true(df_3$public)
  expect_true(identical(mtcars$mpg, jsonlite::fromJSON(df_3$files$file.txt$content)$mpg))
  
  # cleanup
  invisible(suppressMessages(lapply(list(df_1, df_3), delete)))
})

test_that("gist_create_obj works from a matrix", {
  skip_on_cran()
  
  mtmat <- as.matrix(mtcars)
  mat_1 <- gist_create_obj(mtmat, browse = FALSE)
  
  expect_is(mat_1, "gist")
  expect_named(mat_1$files, "file.txt")
  expect_true(mat_1$public)
  
  # cleanup
  invisible(suppressMessages(delete(mat_1)))
})

test_that("gist_create_obj works from a list", {
  skip_on_cran()
  
  mtlist <- apply(mtcars, 1, as.list)
  list_1 <- gist_create_obj(mtlist, browse = FALSE)
  
  expect_is(list_1, "gist")
  expect_named(list_1$files, "file.txt")
  expect_true(list_1$public)
  
  # cleanup
  invisible(suppressMessages(delete(list_1)))
})
