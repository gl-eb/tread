dat <- tecanr::tecan_raw$single_time_multi_reads |>
  tecan_single_time_multiple_reads()

test_that("function returns tibble", {
  expect_true(dat |> is_tibble())
})
