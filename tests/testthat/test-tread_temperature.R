# test deprecation of tread_temperature() ---------------------------------

test_that("tread_temperature() is deprecated", {
  expect_snapshot(
    file_time_series_multiple_reads() |> tread_temperature()
  )
})

test_that("tread_temperature() still works", {
  expect_snapshot({
    old <- file_time_series_multiple_reads() |>
      tread_temperature() |>
      tidyr::drop_na()
    new <- file_time_series_multiple_reads() |>
      tparse() |>
      dplyr::select(time, temp) |>
      dplyr::distinct() |>
      dplyr::rename(temperature = temp) |>
      dplyr::mutate(time = as.integer(time))
    expect_equal(old, new)
  }) |> suppressWarnings()
})

# test correct functioning of tread_temperature() -------------------------

test_that("tread_temperature() runs successfully", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_no_error(
    file_time_series_single_reads() |> tread_temperature()
  )
  expect_no_error(
    file_time_series_multiple_reads() |> tread_temperature()
  )
})


# test detection of non-compliant arguments ------------------------------------

test_that("parser expects file path to be a string", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_error(tread_temperature(3))
})

test_that("parser expects valid file path", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_error(tread_temperature("test.xlsx"))
})

test_that("parser expects sheet number as numeric", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_error(
    file_time_series_multiple_reads() |> tread_temperature("2")
  )
})
