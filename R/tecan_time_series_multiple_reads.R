#' Reads a time series of multiple OD measurements per well from a tecan plate
#' reader excel file
#'
#' @param dat_raw (tibble) a excel sheet
#'
#' @return (tibble) long format data
#'
#' @importFrom data.table :=
tecan_time_series_multiple_reads <- function(dat_raw) {
  # initialize variables and vectors for data search
  time_found <- FALSE
  well_found <- FALSE
  data_found <- FALSE
  wells <- character()
  time <- numeric()
  position_od <- numeric()

  # iterate through rows and extract data
  for (i in 1:dim(dat_raw)[1]) {
    if (is.na(dat_raw[i, 1])) {
      next
    } else if (stringr::str_detect(dat_raw[i, 1], "Cycles / Well")) {
      well_found <- TRUE
    } else if (well_found) {
      wells <- c(wells, dat_raw[i, 1])
      well_found <- FALSE
      data_found <- TRUE
    } else if (data_found && !time_found) {
      time <- dat_raw[i, 2:dim(dat_raw)[2]]
      time_found <- TRUE
    } else if (data_found && stringr::str_detect(dat_raw[i, 1], "Mean")) {
      position_od <- c(position_od, i)
      data_found <- FALSE
    }
  }
  wells <- as.character(wells)
  time <- as.numeric(time)

  # compose data frame using information gathered on first traverse
  dat <- tibble::tibble(time = time)
  for (well in seq_along(wells)) {
    dat <- dat |>
      add_column(!!wells[well] := as.numeric(
        dat_raw[position_od[well], 2:dim(dat_raw)[2]]
      )
      )
  }

  return(dat)
}
