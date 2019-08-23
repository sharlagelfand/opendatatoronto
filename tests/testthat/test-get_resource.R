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
  output <- get_resource("4d985c1d-9c7e-4f74-9864-73214f45eb4a")
  expect_is(output, "tbl_df")
  expect_is(output, "tbl")
  expect_is(output, "data.frame")

  output <- get_resource("bb21e1b8-a466-41c6-8bc3-3c362cb1ed55")
  expect_is(output, "list")

  output <- get_resource("684fdd81-dc1f-4636-a33d-0ede4f390684")
  expect_is(output, "sf")
})

test_that("check_for_sf_geojsonsf return the right warnings when sf or geojson aren't installed.", {
  with_mock(
    "opendatatoronto:::is_sf_installed" = function() FALSE,
    "opendatatoronto:::is_geojsonsf_installed" = function() FALSE,
    expect_warning(check_for_sf_geojsonsf("abcd", "1234"), "The `sf` and `geojsonsf` packages are required to return the GeoJSON resource")
  )
  with_mock(
    "opendatatoronto:::is_sf_installed" = function() FALSE,
    expect_warning(check_for_sf_geojsonsf("abcd", "1234"), "The `sf` package is required to return the GeoJSON resource")
  )
  with_mock(
    "opendatatoronto:::is_geojsonsf_installed" = function() FALSE,
    expect_warning(check_for_sf_geojsonsf("abcd", "1234"), "The `geojsonsf` package is required to parse the geometry of the GeoJSON resource")
  )
})
