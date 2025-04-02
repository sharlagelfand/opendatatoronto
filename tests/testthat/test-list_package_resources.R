context("test-list_package_resources")

test_that("list_package_resources returns an error if the package_id can't be found.", {
  skip_on_cran()
  skip_if_offline()
  expect_error(
    list_package_resources("1234"),
    "not found"
  )
})

test_that("list_package_resources returns the right output formats.", {
  skip_on_cran()
  skip_if_offline()
  package <- list_packages(limit = 1)
  output <- list_package_resources(package)
  expect_is(output, "tbl_df")
  expect_is(output$name, "character")
  expect_is(output$id, "character")
})

# There are no packages with 0 resources anymore
# test_that("list_package_resources returns a zero row tibble when the package has no resources.", {
#   skip_on_cran()
#   skip_if_offline()
#   output <- list_package_resources("8c1f526a-aa13-49af-80bc-69a1c7e3b2ad")
#   expect_equal(nrow(output), 0)
# })

test_that("list_package_resources errors if offline", {
  with_mock(
    "curl::has_internet" = function() FALSE,
    expect_error(list_package_resources("263f54b6-5c60-434f-8958-4e11248f08ff"), "does not work offline")
  )
})
