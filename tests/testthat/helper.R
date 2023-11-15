# provide helper functions that return the path to the various example files
file_single_time_single_reads <- function() system.file(
  "extdata",
  "tecan_single_time_single_reads.xlsx",
  package = "tecanr"
)
file_single_time_multi_reads <- function() system.file(
  "extdata",
  "tecan_single_time_multi_reads.xlsx",
  package = "tecanr"
)
file_time_series_single_reads <- function() system.file(
  "extdata",
  "tecan_time_series_single_reads.xlsx",
  package = "tecanr"
)
file_time_series_multi_reads <- function() system.file(
  "extdata",
  "tecan_time_series_multi_reads.xlsx",
  package = "tecanr"
)

# test tecan_unite() using the supplied example file
test_unite <- function(...) {
    system.file(
      "extdata",
      "tecan_time_series_segments.xlsx",
      package = "tecanr"
    ) |>
    tecan_unite(...)
}
