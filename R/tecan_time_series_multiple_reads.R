#' Reads a time series of multiple OD measurements per well from a tecan plate
#' reader excel file
#'
#' @param dat_raw (tibble) a excel sheet
#'
#' @return (tibble) long format data
#'
#' @importFrom data.table :=
#' @importFrom magrittr %>%
tecan_time_series_multiple_reads <- function(dat_raw) {
  # initialize variables and vectors for data search
  well_found <- FALSE
  well_names <- character()
  well_locs <- numeric()

  # iterate through rows and extract data
  for (i in seq_len(dim(dat_raw)[1])) {
    if (is.na(dat_raw[i, 1])) {
      next
    } else if (stringr::str_detect(dat_raw[i, 1], "Cycles / Well")) {
      well_found <- TRUE
    } else if (well_found) {
      well_names <- c(well_names, dat_raw[i, 1] |> tibble::deframe())
      well_locs <- c(well_locs, i)
      well_found <- FALSE
    }
  }

  # detect number of rows of data per well
  position_relative <- 0
  while (TRUE) {
    position_absolute <- well_locs[1] + position_relative
    if (is.na(dat_raw[position_absolute + 1, 1])) {
      break
    } else {
      position_relative <- position_relative + 1
    }
  }

  # compose data frame using information gathered through parsing
  dat <- tibble::tibble()
  for (well in seq_along(well_names)) {
    # vector of rows to include in data
    rows <- (well_locs[well] + 1):(well_locs[well] + position_relative)
    # vector of columns to include in data (columns of NA are filtered out)
    # magrittr pipe %>% necessary due to complex select condition
    cols <- dat_raw[well_locs[well], ] |>
      (\(data) dplyr::select(!(tidyselect::where(~ all(is.na(data))))))() |>
      seq_along()
    # compose tibble for current well
    dat_well <- dat_raw[rows, cols] |>
      data.table::transpose() |>
      tibble::as_tibble() |>
      janitor::row_to_names(1) |>
      tibble::add_column(
        well = rep(well_names[well], length(cols) - 1),
        .before = 1
      )
    # append current well's data to main tibble
    dat <- dat |> rbind(dat_well)
  }

  return(dat)
}
