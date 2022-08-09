#' Reads the temperature readings corresponding to a timeseries of Tecan
#' Infinite 200 Pro measurements
#'
#' @param xlsx_file (character) path to Excel file
#' @param xlsx_sheet (numeric) number of Excel sheet to read (default: 1)
#'
#' @examples
#' tecan_read_temperature(
#'   system.file(
#'     "extdata",
#'     "tecan_time_series_multi_reads.xlsx",
#'     package = "tecanr"
#'   )
#' )
#'
#' @export
tecan_read_temperature <- function(xlsx_file, xlsx_sheet = 1) {
  # check parameters for validity
  if (!(is.character(xlsx_file))) {
    stop("File path must be a non empty character")
  }
  if (!(is.numeric(xlsx_sheet))) {
    stop("Sheet number must be numeric")
  }

  # import data from excel spreadsheet
  raw_dat <- readxl::read_xlsx(xlsx_file, sheet = xlsx_sheet)

  # initialize variables for data search
  timepoints <- as.integer(dim(raw_dat)[2])

  # iterate through rows and extract data
  for (i in seq_len(dim(raw_dat)[1])) {
    if (is.na(raw_dat[i, 1])) {
      next
    } else if (stringr::str_detect(raw_dat[i, 1], "Temp. \\[.C\\]")) {
      temp <- raw_dat[i, 2:timepoints] |>
        dplyr::slice(1) |>
        as.numeric()
      break
    } else if (stringr::str_detect(raw_dat[i, 1], "Time \\[s\\]")) {
      time <- raw_dat[i, 2:timepoints] |>
        dplyr::slice(1) |>
        as.integer()
    }
  }

  # combine data for plotting
  dat <- tibble::tibble(time = time, temperature = temp)

  return(dat)
}
