# the tests of tunite() make heavy use of test helpers
# these can be found in tests/testthat/helper.R

# test correct functioning of tunite() ------------------------------------

test_that("tunite() runs without errors", {
  expect_no_error(test_unite())
  expect_no_error(test_unite(segments = 2))
  expect_no_error(test_unite(skip = 0))
  expect_no_error(test_unite(segments = 2, skip = 0))
}) |>
suppressMessages()

test_that("tparse() messages are shown by tunite()", {
  expect_message(test_unite(), "Multiple reads")
  expect_message(test_unite(), "Time series")
}) |>
suppressMessages()

test_that("tunite() returns tibble", {
  expect_s3_class(test_unite(), "tbl_df") |> suppressMessages()
})


# test detection of non-compliant arguments ------------------------------------

test_that("file path is valid in tunite()", {
  expect_error(tunite(3), "must be a character")
  expect_error(tunite("test.xlsx"), "does not exist")
})

test_that("numeric tunite() arguments are numeric", {
  expect_error(test_unite(segments = "2"), "must be a whole number")
  expect_error(test_unite(skip = "0"), "must be a whole number")
})

test_that("(segments + skip <= sheets) in tunite()", {
  expect_error(test_unite(segments = 4), "must be smaller")
  expect_error(test_unite(segments = 3, skip = 1), "must be smaller")
})

test_that("segments >= 1 in tunite()", {
  expect_error(test_unite(segments = 0), "`segments` must be >= 1")
  expect_error(test_unite(segments = -3), "`segments` must be >= 1")
})

test_that("skip >= 0 in tunite()", {
  expect_error(test_unite(skip = -1), "`skip` must be >= 0")
})

test_that("tunite() ignores sheets with invalid data", {
  expect_error(
    test_path("fixtures", "time_series_invalid_sheet.xlsx") |>
    tunite() |>
    suppressMessages(),
    "No valid data"
  )
})

test_that("tunite() detects segments overlapping in time", {
  expect_error(
    test_path("fixtures", "time_series_negative_offset.xlsx") |>
    tunite() |>
    suppressMessages()
  )
})
