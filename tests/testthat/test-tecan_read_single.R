test_that("function expects valid file path", {
  expect_error(tecan_read_single("test.xlsx"))
})

test_that("function expects sheet number as numeric", {
  expect_error(
    tecan_read_single(
      system.file("extdata", "tecan_timeSeries_singleReads.xlsx", package = "tecanr"),
      "2"
    )
  )
})
