#' Read multiple measurements per well
#'
#' [single_time_multiple_reads()] gets a Tecan plate reader measurement
#' from an Excel file when multiple readings of each well were taken
#'
#' @param dat_raw (tibble) a excel sheet
#'
#' @return A [tibble::tibble()] containing tidy data
#'
#' @examples
#' traw$single_time_multiple_reads |> single_time_multiple_reads()
#'
#' @export
single_time_multiple_reads <- function(dat_raw) {
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
    } else if (stringr::str_detect(dat_raw[i, 1], "^Well$")) {
      data_start <- i
    }
  }

  # check if data was found
  check_data_found(data_start, data_end)

  # compose data frame using information gathered on first traverse and drop
  # any empty columns; suppress warning about unclean column names
  dat <- dat_raw[data_start:data_end, ] |>
    janitor::row_to_names(row_number = 1) |>
    purrr::discard(~all(is.na(.) | . == "")) |>
    dplyr::mutate(dplyr::across(2:tidyselect::last_col(), as.numeric)) |>
    suppressWarnings()

  return(dat)
}
