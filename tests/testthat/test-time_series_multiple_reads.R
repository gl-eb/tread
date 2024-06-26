# test correct functioning of time_series_multiple_reads -----------------

test_that("time_series_multiple_reads runs without errors", {
  expect_no_error(
    traw$time_series_multiple_reads |> time_series_multiple_reads()
  )
})

test_that("time_series_multiple_reads returns tibble", {
  expect_s3_class(
    traw$time_series_multiple_reads |> time_series_multiple_reads(),
    "tbl_df"
  )
})

test_that("time_series_multiple_reads produces reproducible results", {
  expect_snapshot(
    traw$time_series_multiple_reads |> time_series_multiple_reads()
  )
})


# test detection of non-compliant arguments ------------------------------------

test_that("time_series_multiple_reads expects data frame as input", {
  expect_error(
    time_series_multiple_reads("not a data frame"),
    "must be a data frame"
  )
})

test_that("time_series_multiple_reads expects data in specific format", {
  expect_error(
    traw$single_time_single_reads |> time_series_multiple_reads(),
    "No data found in the expected format"
  )
  expect_error(
    traw$single_time_multiple_reads |> time_series_multiple_reads(),
    "No data found in the expected format"
  )
  expect_error(
    traw$time_series_single_reads |> time_series_multiple_reads(),
    "No data found in the expected format"
  )
})
