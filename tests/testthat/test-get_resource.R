context("get_resource")

test_that('check_id_in_resource returns an error when passed a data frame that doesn\'t contain an "id" column.', {
  expect_error(
    check_id_in_resource(data.frame(a = 1)),
    '`resource` must contain a column "id".'
  )
})

test_that('check_id_in_resource returns the "id" column when present.', {
  res <- check_id_in_resource(data.frame(id = 5))
  expect_equal(
    names(res),
    "id"
  )
})

test_that("as_resource_id throws error when passed a data frame that is not 1 row.", {
  expect_error(
    as_resource_id(
      data.frame(id = c(1, 2))
      ),
    "`resource` must be a 1 row data frame or a length 1 character vector."
  )
  expect_error(
    as_resource_id(
      data.frame(id = character())
    ),
    "`resource` must be a 1 row data frame or a length 1 character vector."
  )
})

test_that("as_resource_id throws error when passed a character vector that is not length 1.", {
  expect_error(
    as_resource_id(
      c("a", "b")
    ),
    "`resource` must be a 1 row data frame or a length 1 character vector."
  )
  expect_error(
    as_resource_id(1),
    "`resource` must be a 1 row data frame or a length 1 character vector."
  )
}
)
