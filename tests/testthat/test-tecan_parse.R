test_that("parser expects file path to be a string", {
  expect_error(tecan_parse(3))
})

test_that("parser expects valid file path", {
  expect_error(tecan_parse("test.xlsx"))
})

test_that("parser expects sheet number as numeric", {
  xlsx_file <- "tecan_timeSeries_multiReads.xlsx"
  xlsx_path <- system.file("extdata", xlsx_file, package = "tecanr")
  expect_error(tecan_parse(xlsx_path, "2"))
})
