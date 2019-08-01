context("test-utils")

test_that("as_id throws error when passed a data frame that is not 1 row.", {
  expect_error(
    as_id(
      data.frame(id = c(1, 2))
    ),
    "must be a 1 row data frame or a length 1 character vector."
  )
  expect_error(
    as_id(
      data.frame(id = character())
    ),
    "must be a 1 row data frame or a length 1 character vector."
  )
})
