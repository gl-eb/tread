# the tests of tecan_unite() make heavy use of test helpers
# these can be found in tests/testthat/helper.R

# test correct functioning of tecan_unite() -------------------------

test_that("tecan_unite() runs without errors", {
  expect_no_error(test_assemble())
  expect_no_error(test_assemble(segments = 2))
  expect_no_error(test_assemble(skip = 0))
  expect_no_error(test_assemble(segments = 2, skip = 0))
}) |>
suppressMessages()

test_that("tecan_parse() messages are shown by tecan_unite()", {
  expect_message(test_assemble(), "Multiple reads")
  expect_message(test_assemble(), "Time series")
}) |>
suppressMessages()

test_that("tecan_unite() returns tibble", {
  expect_s3_class(test_assemble(), "tbl_df") |> suppressMessages()
})


# test detection of non-compliant arguments ------------------------------------

test_that("file path is string in tecan_unite()", {
  expect_error(
    tecan_unite(3),
    "must be a character"
  )
})

test_that("file path is valid in tecan_unite()", {
  expect_error(
    tecan_unite("test.xlsx"),
    "does not exist"
  )
})

test_that("(segments + skip <= sheets) in tecan_unite()", {
  expect_error(test_assemble(segments = 4), "must be smaller")
  expect_error(test_assemble(segments = 3, skip = 1), "must be smaller")
})

test_that("segments >= 1 in tecan_unite()", {
  expect_error(test_assemble(segments = 0), "`segments` must be >= 1")
  expect_error(test_assemble(segments = -3), "`segments` must be >= 1")
})

test_that("tecan_unite() ignores sheets with invalid data", {
  expect_no_error(
    test_path("fixtures", "time_series_invalid_sheet.xlsx") |>
    tecan_unite() |>
    suppressMessages()
  )
})

test_that("tecan_unite() detects segments overlapping in time", {
  expect_error(
    test_path("fixtures", "time_series_negative_offset.xlsx") |>
    tecan_unite() |>
    suppressMessages()
  )
})
