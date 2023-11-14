test_that("parser expects file path to be a string", {
  expect_error(assemble_data_segments(3))
})

test_that("parser expects valid file path", {
  expect_error(assemble_data_segments("test.xlsx"))
})

test_that("function should run without errors", {
  expect_no_error(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments()
  )
})

test_that("output should be tibble", {
  expect_s3_class(
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(),
    "tbl_df"
  )
})
