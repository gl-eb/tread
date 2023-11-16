# test correct functioning of tecan_parse() ------------------------------------

test_that("tecan_parse() runs successfully for all data formats", {
  expect_no_error(
    file_single_time_single_reads() |> tecan_parse()
  )
  expect_no_error(
    file_single_time_multi_reads() |> tecan_parse()
  )
  expect_no_error(
    file_time_series_single_reads() |> tecan_parse()
  )
  expect_no_error(
    file_time_series_multi_reads() |> tecan_parse()
  )
}) |> suppressMessages()

test_that("tacan_parse() messages correctly", {
  expect_no_message(
    file_single_time_single_reads() |> tecan_parse()
  )
  expect_message(
    file_single_time_multi_reads() |> tecan_parse()
  )
  expect_message(
    file_time_series_single_reads() |> tecan_parse(),
    "Time series detected"
  )
  expect_message(
    file_time_series_multi_reads() |> tecan_parse()
  )
})

# test detection of non-compliant arguments ------------------------------------

test_that("parser expects file path to be a string", {
  expect_error(tecan_parse(3))
})

test_that("parser expects valid file path", {
  expect_error(tecan_parse("test.xlsx"))
})

test_that("parser expects sheet number as numeric", {
  expect_error(
    file_single_time_multi_reads() |> tecan_parse("2")
  )
})
