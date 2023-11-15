# test tecan_unite() using the supplied example file
test_unite <- function(...) {
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    tecan_unite(...)
}
