#' Parses a Tecan Infinite 200 Pro plate reader excel file, determines the type
#' of measurement (single time point or series, single or multiple reads per
#' well), and reads the data
#'
#' @param xlsx_file (character) path to Excel file
#' @param xlsx_sheet (numeric) number of Excel sheet to read (default: 1)
#'
#' @return (tibble) long format data
#'
#' @import tibble
#' @importFrom readxl read_xlsx
#' @importFrom stringr str_detect
#'
#' @examples
#' tecan_parse(
#'   system.file(
#'     "extdata",
#'     "tecan_timeSeries_multiReads.xlsx",
#'     package = "tecanr"
#'   )
#' )
#'
#' @export
tecan_parse <- function(xlsx_file, xlsx_sheet = 1) {
  # check parameters for validity
  if (!(is.character(xlsx_file))) {
    stop("File path must be a non empty character")
  }
  if (!(is.numeric(xlsx_sheet))) {
    stop("Sheet number must be numeric")
  }

  # import data from excel spreadsheet
  raw_dat <- read_xlsx(xlsx_file, sheet = xlsx_sheet, col_names = F)

  # initialize variables and vectors for data search
  multiple_reads <- FALSE
  time_series <- FALSE

  # iterate through rows and extract data
  for (i in 1:dim(raw_dat)[1]) {
    if (is.na(raw_dat[i, 1])) {
      # skip row if empty
      next
    } else if (str_detect(raw_dat[i, 1], "Multiple Reads")) {
      # detect if multiple reads per well were taken
      multiple_reads <- TRUE
      print("Multiple reads per well detected")
    } else if (str_detect(raw_dat[i, 1], "Cycle")) {
      # detect if measurements are time series
      time_series <- TRUE
      print("Time series detected")
    } else if (multiple_reads) {
      # if multiple reads per well were taken
      if (time_series) {
        # if data is time series of multiple reads per well
      } else {
        # if data is from single time point but multiple reads per well
      }
    } else if (!multiple_reads) {
      # if single read per well was taken
      if (time_series) {
        # if data is time series of single reads per well
      } else {
        # if data is from single time point and a single read per well
      }
    }
  }

  #return(dat)
}
