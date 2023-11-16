# test correct functioning of tecan_single_time_single_reads -----------------

test_that("tecan_single_time_single_reads runs without errors", {
  expect_no_error(
    tecan_raw$single_time_single_reads |> tecan_single_time_single_reads()
  )
})

test_that("tecan_single_time_single_reads returns tibble", {
  expect_s3_class(
    tecan_raw$single_time_single_reads |> tecan_single_time_single_reads(),
    "tbl_df"
  )
})

test_that("tecan_single_time_single_reads produces reproducible results", {
  expect_snapshot(
    tecan_raw$single_time_single_reads |> tecan_single_time_single_reads()
  )
})


# test detection of non-compliant arguments ------------------------------------

test_that("tecan_single_time_single_reads expects data frame as input", {
  expect_error(
    tecan_single_time_single_reads("not a data frame"),
    "must be a data frame"
  )
})

test_that("tecan_single_time_single_reads expects data in specific format", {
  expect_error(
    tecan_raw$single_time_multi_reads |> tecan_single_time_single_reads(),
    "No data found in the expected format"
  )
  expect_error(
    tecan_raw$time_series_single_reads |> tecan_single_time_single_reads(),
    "No data found in the expected format"
  )
  expect_error(
    tecan_raw$time_series_multi_reads |> tecan_single_time_single_reads(),
    "No data found in the expected format"
  )
})
