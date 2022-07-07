#' Reads a single time point of multiple OD measurements per well from a tecan
#' plate reader excel file
#'
#' @param dat_raw (tibble) a excel sheet
#'
#' @return (tibble) long format data
tecan_single_time_multiple_reads <- function(dat_raw) {
# initialize variables and vectors for data search
  data_start <- numeric()
  data_end <- numeric()

  # iterate through rows and extract data
  for (i in 1:dim(dat_raw)[1]) {
    if (is.na(dat_raw[i, 1])) {
      if (length(data_start) > 0 && length(data_end) == 0) {
        data_end <- i - 1
      }
    } else if (stringr::str_detect(dat_raw[i, 1], "^Well$")) {
      data_start <- i
    }
  }

  # compose data frame using information gathered on first traverse
  dat <- dat_raw[data_start:data_end, 1:8] |>
    janitor::row_to_names(row_number = 1)

  return(dat)
}
