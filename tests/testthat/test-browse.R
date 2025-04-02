context("test-browse")

test_that("browse_portal returns the portal URL", {
  skip_on_cran()
  skip_if_offline()
  expect_equal(browse_portal(), "https://open.toronto.ca")
})

test_that("browse_package returns the package page URL", {
  skip_on_cran()
  skip_if_offline()
  expect_equal(
    browse_package("996cfe8d-fb35-40ce-b569-698d51fc683b"),
    "https://open.toronto.ca/dataset/ttc-subway-delay-data"
  )
})

test_that("browse_resource returns the resource's package page URL", {
  skip_on_cran()
  skip_if_offline()
  expect_equal(
    browse_resource("fed58a09-14bc-403f-9166-00397c7822a7"),
    "https://open.toronto.ca/dataset/ttc-subway-delay-data"
  )
})

test_that("browse_portal, browse_resource, browse_package error if offline", {
  with_mocked_bindings(
    has_internet = function() FALSE,
    .package = "curl",
    code = {
      expect_error(browse_portal(), "does not work offline")
      expect_error(browse_resource(), "does not work offline")
      expect_error(browse_package(), "does not work offline")
    }
  )
})
