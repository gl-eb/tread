dat <- tecanr::dat_raw$time_series_multi_reads |>
  tecan_time_series_multiple_reads()

test_that("function returns tibble", {
  expect_true(dat |> is_tibble())
})
