# test deprecation of tecan_read_temperature() ---------------------------------

test_that("tecan_read_temperature() is deprecated", {
  expect_snapshot(
    file_time_series_multiple_reads() |> tecan_read_temperature()
  )
})

test_that("tecan_read_temperature() still works", {
  expect_snapshot({
    old <- file_time_series_multiple_reads() |>
      tecan_read_temperature() |>
      tidyr::drop_na()
    new <- file_time_series_multiple_reads() |>
      tecan_parse() |>
      dplyr::select(time_s, temp_c) |>
      dplyr::distinct() |>
      dplyr::rename(time = time_s, temperature = temp_c) |>
      dplyr::mutate(time = as.integer(time))
    expect_equal(old, new)
  }) |> suppressWarnings()
})

# test correct functioning of tecan_read_temperature() -------------------------

test_that("tecan_read_temperature() runs successfully", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_no_error(
    file_time_series_single_reads() |> tecan_read_temperature()
  )
  expect_no_error(
    file_time_series_multiple_reads() |> tecan_read_temperature()
  )
})


# test detection of non-compliant arguments ------------------------------------

test_that("parser expects file path to be a string", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_error(tecan_read_temperature(3))
})

test_that("parser expects valid file path", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_error(tecan_read_temperature("test.xlsx"))
})

test_that("parser expects sheet number as numeric", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_error(
    file_time_series_multiple_reads() |> tecan_read_temperature("2")
  )
})
