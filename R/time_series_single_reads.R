#' Read time series of measurements
#'
#' [time_series_single_reads()] gets a time series of Tecan plate reader
#' measurements from an Excel file when a single reading was taken of each well
#'
#' @param dat_raw (tibble) a excel sheet
#'
#' @return A [tibble::tibble()] containing tidy data
#'
#' @examples
#' traw$time_series_single_reads |> time_series_single_reads()
#'
#' @export
time_series_single_reads <- function(dat_raw) {
  # check input for validity
  check_data_frame(dat_raw)

  # initialize variables and vectors for data search
  data_start <- numeric()
  data_end <- numeric()

  # iterate through rows and extract data
  for (i in seq_len(dim(dat_raw)[1])) {
    if (is.na(dat_raw[i, 1])) {
      if (length(data_start) > 0 && length(data_end) == 0) {
        data_end <- i - 1
      }
    } else if (stringr::str_detect(dat_raw[i, 1], "^Cycle Nr.$")) {
      data_start <- i
    }
  }

  # check if data was found
  check_data_found(data_start, data_end)

  # compose data frame using information gathered on first traverse
  dat <- dat_raw[data_start:data_end, ] |>
    dplyr::select(!(tidyselect::where(~ all(is.na(.x))))) |>
    data.table::transpose() |>
    tibble::as_tibble() |>
    janitor::row_to_names(row_number = 1) |>
    dplyr::mutate(dplyr::across(tidyselect::everything(), as.numeric)) |>
    tidyr::pivot_longer(
      cols = 4:tidyselect::last_col(),
      names_to = "well",
      values_to = "value"
    ) |>
    dplyr::relocate("well") |>
    tidyr::drop_na()

  return(dat)
}
