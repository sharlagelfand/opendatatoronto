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

test_that("check_resource_found errors when the resource doesn't exist.", {
  res <- try(ckanr::resource_show("12345"), silent = TRUE)
  expect_error(
    check_resource_found(res, "12345"),
    '`resource` "12345" was not found.'
  )
})

test_that("check_format throws an error when format is not one of CSV, XLS, XLSX, XML, JSON, SHP, ZIP, GEOJSON and returns the format when it is.", {
  expect_error(check_format("DOC"))
  expect_error(check_format("WEB"))
  expect_error(check_format("PDF"))
  expect_error(check_format("SAV"))
  expect_equal(check_format("CSV"), "CSV")
  expect_equal(check_format("XLS"), "XLS")
  expect_equal(check_format("XLSX"), "XLSX")
  expect_equal(check_format("XML"), "XML")
  expect_equal(check_format("JSON"), "JSON")
  expect_equal(check_format("SHP"), "SHP")
  expect_equal(check_format("ZIP"), "ZIP")
  expect_equal(check_format("GEOJSON"), "GEOJSON")
})
