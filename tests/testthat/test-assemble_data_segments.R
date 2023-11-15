# test correct functioning of assemble_data_segments() -------------------------

test_that("function should run without errors", {
  expect_no_error(test_assemble())
  expect_no_error(test_assemble(segments = 2))
  expect_no_error(test_assemble(skip = 0))
  expect_no_error(test_assemble(segments = 2, skip = 0))
}) |>
suppressMessages()

test_that("tecan_parse's messages should be printed", {
  expect_message(test_assemble(), "Multiple reads")
  expect_message(test_assemble(), "Time series")
}) |>
suppressMessages()

test_that("output should be tibble", {
  expect_s3_class(test_assemble(), "tbl_df") |> suppressMessages()
})


# test detection of non-compliant arguments ------------------------------------

test_that("file path should be string", {
  expect_error(
    assemble_data_segments(3),
    "must be a character"
  )
})

test_that("file path should be valid", {
  expect_error(
    assemble_data_segments("test.xlsx"),
    "does not exist"
  )
})

test_that("expect segments + skip <= sheets", {
  expect_error(test_assemble(segments = 4), "must be smaller")
  expect_error(test_assemble(segments = 3, skip = 1), "must be smaller")
})

test_that("number of segments should be >= 1", {
  expect_error(test_assemble(segments = 0), "`segments` must be >= 1")
  expect_error(test_assemble(segments = -3), "`segments` must be >= 1")
})

test_that("sheets with invalid data should be ignored", {
  expect_no_error(
    test_path("fixtures", "time_series_invalid_sheet.xlsx") |>
    assemble_data_segments() |>
    suppressMessages()
  )
})

test_that("segments should not overlap in time", {
  expect_error(
    test_path("fixtures", "time_series_negative_offset.xlsx") |>
    assemble_data_segments() |>
    suppressMessages()
  )
})
