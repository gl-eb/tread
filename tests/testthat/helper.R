# provide helper functions that return the path to the various example files
file_single_time_single_reads <- function() system.file(
  "extdata",
  "single_time_single_reads.xlsx",
  package = "tread"
)
file_single_time_multiple_reads <- function() system.file(
  "extdata",
  "single_time_multiple_reads.xlsx",
  package = "tread"
)
file_time_series_single_reads <- function() system.file(
  "extdata",
  "time_series_single_reads.xlsx",
  package = "tread"
)
file_time_series_multiple_reads <- function() system.file(
  "extdata",
  "time_series_multiple_reads.xlsx",
  package = "tread"
)

# test tunite() using the supplied example file
test_unite <- function(...) {
    system.file(
      "extdata",
      "time_series_segments.xlsx",
      package = "tread"
    ) |>
    tunite(...)
}
