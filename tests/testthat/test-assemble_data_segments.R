# test correct functioning of assemble_data_segments() -------------------------

test_that("assemble_data_segments() runs without errors", {
  expect_no_error(test_assemble())
  expect_no_error(test_assemble(segments = 2))
  expect_no_error(test_assemble(skip = 0))
  expect_no_error(test_assemble(segments = 2, skip = 0))
}) |>
suppressMessages()

test_that("tecan_parse() messages are shown by assemble_data_segments()", {
  expect_message(test_assemble(), "Multiple reads")
  expect_message(test_assemble(), "Time series")
}) |>
suppressMessages()

test_that("assemble_data_segments() returns tibble", {
  expect_s3_class(test_assemble(), "tbl_df") |> suppressMessages()
})


# test detection of non-compliant arguments ------------------------------------

test_that("file path is string in assemble_data_segments()", {
  expect_error(
    assemble_data_segments(3),
    "must be a character"
  )
})

test_that("file path is valid in assemble_data_segments()", {
  expect_error(
    assemble_data_segments("test.xlsx"),
    "does not exist"
  )
})

test_that("(segments + skip <= sheets) in assemble_data_segments()", {
  expect_error(test_assemble(segments = 4), "must be smaller")
  expect_error(test_assemble(segments = 3, skip = 1), "must be smaller")
})

test_that("segments >= 1 in assemble_data_segments()", {
  expect_error(test_assemble(segments = 0), "`segments` must be >= 1")
  expect_error(test_assemble(segments = -3), "`segments` must be >= 1")
})

test_that("assemble_data_segments() ignores sheets with invalid data", {
  expect_no_error(
    test_path("fixtures", "time_series_invalid_sheet.xlsx") |>
    assemble_data_segments() |>
    suppressMessages()
  )
})

test_that("assemble_data_segments() detects segments overlapping in time", {
  expect_error(
    test_path("fixtures", "time_series_negative_offset.xlsx") |>
    assemble_data_segments() |>
    suppressMessages()
  )
})
