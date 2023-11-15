# test assemble_data_segments() using the supplied example file
test_assemble <- function(...) {
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    assemble_data_segments(...)
}
