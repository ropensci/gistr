# tests for gist function
context("gist")

test_that("gist works", {
  skip_on_cran()
  
  expect_is(gist(id = 'f1403260eb92f5dfa7e1'), "gist")
})

test_that("as.gist works - character gist ID input", {
  skip_on_cran()
  
  expect_is(as.gist('f1403260eb92f5dfa7e1'), "gist")
  expect_is(as.gist(10), "gist")
  expect_is(as.gist(gist('f1403260eb92f5dfa7e1')), "gist")
})

test_that("as.gist works - on random sample of gist ids", {
  skip_on_cran()
  
  gsts <- gists()
  ids <- vapply(gsts, "[[", "", "id")
  invisible(lapply(ids, function(z) {
    expect_is(as.gist(z), "gist")
  }))
})

test_that("gist works getting a specific revision", {
  skip_on_cran()
  
  id <- 'c1e2cb547d9f22bd314da50fe9c7b503'
  rev1 <- gist(id, 'a5bc5c143beb697f23b2c320ff5a8dacf960b0f3')
  rev2 <- gist(id, 'b70d94a8222a4326dff46fc85bc69d0179bd1da2')

  expect_false(
    identical(
      rev1$files$clean_species.R$content,
      rev2$files$clean_species.R$content
    )
  )
  expect_match(rev1$id, rev2$id)
})

test_that("httr config options work", {
  skip_on_cran()
  
  library('httr')
  expect_error(gist(10, config = timeout(0.001)))
})

test_that("passing in a URL or URL fragment", {
  skip_on_cran()
  
  x <- "https://gist.github.com/expersso/4ac33b9c00751fddc7f8"
  gurl <- as.gist(x)
  gurl2 <- gist(x)
  expect_is(gurl, "gist")
  expect_is(gurl2, "gist")
  expect_equal(gurl, gurl2)
  
  # fragments work
  expect_is(gist("gist.github.com/expersso/4ac33b9c00751fddc7f8"), "gist")
  expect_is(gist("gist.github.com/4ac33b9c00751fddc7f8"), "gist")
  expect_is(gist("expersso/4ac33b9c00751fddc7f8"), "gist")
  
  # not a real url
  expect_error(gist("httpb://stuff.com"), "Not Found")
  # no id at end of url
  expect_error(gist("https://gist.github.com/expersso"), "Not Found")
})
