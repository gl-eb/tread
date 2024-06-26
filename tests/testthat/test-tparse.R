# test correct functioning of tparse() ------------------------------------

test_that("tparse() runs successfully for all data formats", {
  expect_no_error(
    file_single_time_single_reads() |> tparse()
  )
  expect_no_error(
    file_single_time_multiple_reads() |> tparse()
  )
  expect_no_error(
    file_time_series_single_reads() |> tparse()
  )
  expect_no_error(
    file_time_series_multiple_reads() |> tparse()
  )
}) |> suppressMessages()

test_that("tparse() messages correctly", {
  expect_no_message(
    file_single_time_single_reads() |> tparse()
  )
  expect_message(
    file_single_time_multiple_reads() |> tparse(),
    "Multiple reads per well detected"
  )
  expect_message(
    file_time_series_single_reads() |> tparse(),
    "Time series detected"
  )
  expect_message(
    file_time_series_multiple_reads() |> tparse(),
    "Time series detected"
  ) |> suppressMessages()
  expect_message(
    file_time_series_multiple_reads() |> tparse(),
    "Multiple reads per well detected"
  ) |> suppressMessages()
})

# test detection of non-compliant arguments ------------------------------------

test_that("parser expects file path to be a string", {
  expect_error(tparse(3))
})

test_that("parser expects valid file path", {
  expect_error(tparse("test.xlsx"))
})

test_that("parser expects sheet number as numeric", {
  expect_error(
    file_single_time_multiple_reads() |> tparse("2")
  )
})
