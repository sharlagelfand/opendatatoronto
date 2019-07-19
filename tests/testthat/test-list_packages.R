context("test-list_packages")

test_that("list_packages returns error if limit is not a length 1 positive integer.", {
  expect_error(
    list_packages(limit = -1),
    "`limit` must be a positive integer."
  )
  expect_error(
    list_packages(limit = 0),
    "`limit` must be a positive integer."
  )
  expect_error(
    list_packages(limit = -Inf),
    "`limit` must be a positive integer."
  )
  expect_error(
    list_packages(limit = 1.2),
    "`limit` must be a positive integer."
  )
  expect_error(
    list_packages(limit = c(1, 2)),
    "`limit` must be a length 1 positive integer."
  )
})

test_that("list_packages returns the right output formats.", {
  skip_on_cran()
  output <- list_packages(1)
  expect_is(output, "tbl_df")
  expect_is(output$title, "character")
  expect_is(output$id, "character")
  expect_is(output$topics, "character")
  expect_is(output$excerpt, "character")
  expect_is(output$dataset_category, "character")
  expect_is(output$formats, "list")
  expect_is(output$refresh_rate, "character")
})
