context("test-list_package_resources")

test_that("list_package_resources returns an error if the package_id can't be found.", {
  expect_error(
    list_package_resources("1234"),
    "not found"
  )
})

test_that("list_package_resources returns the right output formats.", {
  skip_on_cran()
  output <- list_package_resources("263f54b6-5c60-434f-8958-4e11248f08ff")
  expect_is(output, "tbl_df")
  expect_is(output$name, "character")
  expect_is(output$id, "character")
})
