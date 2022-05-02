#' Reads the temperature readings corresponding to a timeseries of Tecan
#' Infinite 200 Pro measurements
#'
#' @param xlsx_file (character) path to Excel file
#' @param xlsx_sheet (numeric) number of Excel sheet to read (default: 1)
#'
#' @import tibble
#' @importFrom dplyr slice
#' @importFrom readxl read_xlsx
#' @importFrom stringr str_detect
#'
#' @examples
#' tecan_read_temperature(
#'   system.file(
#'     "extdata",
#'     "tecan_timeSeries_multiReads.xlsx",
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
  raw_dat <- read_xlsx(xlsx_file, sheet = xlsx_sheet) # skip = 61, n_max = 1

  # initialize variables for data search
  time_found <- FALSE
  timepoints <- as.integer(dim(raw_dat)[2])

  # iterate through rows and extract data
  for (i in 1:dim(raw_dat)[1]) {
    if (is.na(raw_dat[i, 1])) {
      next
    } else if (str_detect(raw_dat[i, 1], "Temp. \\[.C\\]")) { # time_found &&
      temp <- raw_dat[i, 2:timepoints] |>
        slice(1) |>
        as.numeric()
      break
    } else if (str_detect(raw_dat[i, 1], "Time \\[s\\]")) {
      time_found <- TRUE
      time <- raw_dat[i, 2:timepoints] |>
        slice(1) |>
        as.integer()
    }
  }

  # combine data for plotting
  dat <- tibble(time = time, temperature = temp)

  return(dat)
}
