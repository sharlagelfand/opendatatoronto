context("test-get_package_resources")

test_that("get_package_resources returns an error if package_id is not a length 1 character vector", {
  expect_error(
    get_package_resources(1234),
    "must be a character vector"
  )
  expect_error(
    get_package_resources(c("1234", "5678")),
    "must be a length 1 character vector"
  )
})

test_that("get_package_resources returns an error if the package_id can't be found.", {
  expect_error(
    get_package_resources("1234"),
    "not found"
  )
})

test_that("get_package_resources returns the right output formats.", {
  skip_on_cran()
  output <- get_package_resources("680d4f11-9bb2-4efe-9b13-50b34d8eba10")
  expect_is(output, "tbl_df")
  expect_is(output$name, "character")
  expect_is(output$id, "character")
  expect_is(output$format, "character")
  expect_is(output$created, "character")
  expect_is(output$url, "character")
})
