context("download_resource")

test_that("download_resource returns error that unsupported formats must be downloaded from Portal directly.", {
  expect_error(
    download_resource(
      url = "test_url",
      format = "DOCX"
    ),
    regexp = "*can't be downloaded via package*"
  )

  expect_error(
    download_resource(
      url = "test_url",
      format = "DOC"
    ),
    regexp = "*can't be downloaded via package*"
  )
})
