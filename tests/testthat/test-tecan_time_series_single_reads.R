# test correct functioning of tecan_time_series_single_reads -----------------

test_that("tecan_time_series_single_reads returns tibble", {
  expect_s3_class(
    tecan_raw$time_series_single_reads |>
    tecan_time_series_single_reads(),
    "tbl_df"
  )
})


# test detection of non-compliant arguments ------------------------------------

test_that("tecan_time_series_single_reads expects data frame as input", {
  expect_error(
    tecan_time_series_single_reads("not a data frame"),
    "must be a data frame"
  )
})
