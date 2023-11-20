# test correct functioning of tecan_time_series_multiple_reads -----------------

test_that("tecan_time_series_multiple_reads runs without errors", {
  expect_no_error(
    tecan_raw$time_series_multiple_reads |> tecan_time_series_multiple_reads()
  )
})

test_that("tecan_time_series_multiple_reads returns tibble", {
  expect_s3_class(
    tecan_raw$time_series_multiple_reads |> tecan_time_series_multiple_reads(),
    "tbl_df"
  )
})

test_that("tecan_time_series_multiple_reads produces reproducible results", {
  expect_snapshot(
    tecan_raw$time_series_multiple_reads |> tecan_time_series_multiple_reads()
  )
})


# test detection of non-compliant arguments ------------------------------------

test_that("tecan_time_series_multiple_reads expects data frame as input", {
  expect_error(
    tecan_time_series_multiple_reads("not a data frame"),
    "must be a data frame"
  )
})

test_that("tecan_time_series_multiple_reads expects data in specific format", {
  expect_error(
    tecan_raw$single_time_single_reads |> tecan_time_series_multiple_reads(),
    "No data found in the expected format"
  )
  expect_error(
    tecan_raw$single_time_multiple_reads |> tecan_time_series_multiple_reads(),
    "No data found in the expected format"
  )
  expect_error(
    tecan_raw$time_series_single_reads |> tecan_time_series_multiple_reads(),
    "No data found in the expected format"
  )
})
