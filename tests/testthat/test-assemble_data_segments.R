# test correct functioning of assemble_data_segments() -------------------------

test_that("function should run without errors", {
  expect_no_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments() |>
    suppressMessages()
  )
  expect_no_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(segments = 2) |>
    suppressMessages()
  )
  expect_no_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(skip = 0) |>
    suppressMessages()
  )
  expect_no_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(segments = 2, skip = 0) |>
    suppressMessages()
  )
})

test_that("tecan_parse's messages should be printed", {
  expect_message(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(),
    "Multiple reads"
  ) |> suppressMessages()
  expect_message(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(),
    "Time series"
  ) |> suppressMessages()
})

test_that("output should be tibble", {
  expect_s3_class(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments() |>
    suppressMessages(),
    "tbl_df"
  )
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
  expect_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(segments = 4),
    "must be smaller"
  )
  expect_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(segments = 3, skip = 1),
    "must be smaller"
  )
})

test_that("number of segments should be >= 1", {
  expect_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(segments = 0),
    "`segments` must be >= 1"
  )
  expect_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(segments = -3),
    "`segments` must be >= 1"
  )
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
