test_that("function expects valid file path", {
  expect_error(tecan_read_series("test.xlsx"))
})

test_that("function expects sheet number as numeric", {
  expect_error(
    tecan_read_series(
      system.file("extdata", "tecan_timeSeries_multiReads.xlsx", package = "tecanr"),
      "2"
    )
  )
})
