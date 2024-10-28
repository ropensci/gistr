test_that("gitcreds finds PAT", {
  expect_equal(gitcreds::gitcreds_get()$password, Sys.getenv("GITHUB_PAT"))
})


test_that("gist_auth finds PAT", {
  skip_on_cran()
  auth <- gist_auth(reauth = TRUE)
  expect_equal(
    auth$Authorization,
    paste0("token ", gitcreds::gitcreds_get()$password)
  )
})

#can't (easily) test PAT stored with gitcreds::gitcreds_set() or interactive oauth

test_that("valid_gh_pat() works", {
  expect_false(valid_gh_pat("hello"))
  expect_false(valid_gh_pat(""))
  expect_false(valid_gh_pat(NULL))
})
