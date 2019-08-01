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

test_that("as_id throws error when passed a list.", {
  expect_error(
    as_id(list(id = 1)),
    "must be a 1 row data frame or a length 1 character vector."
  )
})

test_that("as_id throws error when passed vector of length greater than 1.", {
  expect_error(
    as_id(c("ab", "cd")),
    "must be a 1 row data frame or a length 1 character vector."
  )
})

test_that("as_id throws error when passed a zero-length vector.", {
  expect_error(
    as_id(character()),
    "must be a 1 row data frame or a length 1 character vector."
  )
})

test_that("as_id throws error when passed a non-character vector.", {
  expect_error(
    as_id(1),
    "must be a 1 row data frame or a length 1 character vector."
  )
  expect_error(
    as_id(TRUE),
    "must be a 1 row data frame or a length 1 character vector."
  )
})

test_that('as_id returns the contents of the "id" column when it is passed a 1 row data frame.', {
  id <- "abcde"
  expect_equal(
    as_id(data.frame(id = id)),
    id
  )
})
