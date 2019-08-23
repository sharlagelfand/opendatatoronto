context("test-browse")

test_that("browse_portal returns the portal URL", {
  expect_equal(browse_portal(), "https://open.toronto.ca")
})

test_that("browse_package returns the package page URL", {
  expect_equal(browse_package("996cfe8d-fb35-40ce-b569-698d51fc683b"), "https://open.toronto.ca/dataset/ttc-subway-delay-data")
})

test_that("browse_resource returns the resource's package page URL", {
  expect_equal(browse_resource("655a138c-d381-4fe7-b3b3-a6620825161f"), "https://open.toronto.ca/dataset/ttc-subway-delay-data")
})

test_that("parse_package_title replaces non-alphanumeric characters with '-', converts to lowercase, strips repeating -s, and doesn't allow ending with a -", {
  expect_equal(parse_package_title("here is a test"), "here-is-a-test")
  expect_equal(parse_package_title("HERE IS ANOTHER"), "here-is-another")
  expect_equal(parse_package_title("and another one!"), "and-another-one")
  expect_equal(parse_package_title("one    more for good measure"), "one-more-for-good-measure")
  expect_equal(parse_package_title("1234 better check some numbers more!"), "1234-better-check-some-numbers-more")
})
