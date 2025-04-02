context("get_resource")

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

test_that("get_resource returns the right output formats.", {
  skip_on_cran()
  skip_if_offline()
  output <- get_resource("fed58a09-14bc-403f-9166-00397c7822a7")
  expect_is(output, "tbl_df")
  expect_is(output, "tbl")
  expect_is(output, "data.frame")

  output <- get_resource("e93a7088-d37b-484e-addb-0f9eec4dfa19")
  expect_is(output, "list")

  # SHP
  output <- get_resource("75caaa71-0a7b-4f89-a573-7cfe07c1aa3d")
  expect_is(output, "sf")

  # GeoJSON
  output <- get_resource("199bba5c-242e-4968-ae7f-2e2147eaf235")
  expect_is(output, "sf")

  output <- get_resource("585c1ca2-9195-452e-ad76-8c982b0941aa")
  expect_is(output, "tbl_df")
})

test_that("tibble_list_elements makes data frame list elements into tibbles", {
  x <- list(
    a = data.frame(b = 1),
    c = data.frame(d = 1)
  )
  x_tibble <- tibble_list_elements(x)
  expect_equal(names(x), names(x_tibble))
  expect_is(x_tibble[["a"]], "tbl_df")
  expect_is(x_tibble[["c"]], "tbl_df")
})

test_that("tibble_list_elements does not make columns of data frames into tibbles", {
  x <- data.frame(
    b = 1,
    c = 1
  )
  x_tibble <- tibble_list_elements(x)
  expect_equal(names(x), names(x_tibble))
  expect_is(x_tibble, "tbl_df")
})

test_that("nested_lapply_tibble makes data frame list elements into tibbles and doesn't make data frame columns into tibbles", {
  x <- list(
    a = data.frame(b = 1),
    c = data.frame(d = 1)
  )
  y <- data.frame(
    b = 1,
    c = 1
  )
  z <- list(x = x, y = y)
  z_tibble <- nested_lapply_tibble(z)
  expect_equal(names(z), names(z_tibble))
  expect_equal(names(z[["x"]]), names(z_tibble[["x"]]))
  expect_is(z_tibble[["x"]][["a"]], "tbl_df")
  expect_is(z_tibble[["x"]][["c"]], "tbl_df")
  expect_is(z_tibble[["y"]], "tbl_df")
})

test_that("get_resource errors if offline", {
  with_mocked_bindings(
    has_internet = function() FALSE,
    .package = "curl",
    code = expect_error(get_resource("4d985c1d-9c7e-4f74-9864-73214f45eb4a"), "does not work offline")
  )
})
