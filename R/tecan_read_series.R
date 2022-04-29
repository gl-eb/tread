#' Reads a time series of measurements from a tecan plate reader excel file
#'
#' @param xlsx_file (character) path to Excel file
#' @param xlsx_sheet (numeric) number of Excel sheet to read (default: 1)
#'
#' @return (tibble) long format data
#'
#' @import tibble
#' @importFrom data.table :=
#' @importFrom magrittr %>%
#' @importFrom readxl read_xlsx
#' @importFrom stringr str_detect
#'
#' @examples
#' tecan_read_series(system.file("extdata", "tecan_series.xlsx", package = "tecanr"))
#'
#' @export
tecan_read_series <- function(xlsx_file, xlsx_sheet = 1) {
  # check parameters for validity
  if (!(is.character(xlsx_file))) {
    stop("File path must be a non empty character")
  }
  if (!(is.numeric(xlsx_sheet))) {
    stop("Sheet number must be numeric")
  }

  # import data from excel spreadsheet
  raw_dat <- readxl::read_xlsx(xlsx_file, sheet = xlsx_sheet, col_names = F)

  # initialize variables and vectors for data search
  time_found <- FALSE
  well_found <- FALSE
  data_found <- FALSE
  wells <- character()
  time <- numeric()
  position_od <- numeric()

  # iterate through rows and extract data
  for (i in 1:dim(raw_dat)[1]) {
    if (is.na(raw_dat[i, 1])) {
      next
    } else if (stringr::str_detect(raw_dat[i, 1], "Cycles / Well")) {
      well_found <- TRUE
    } else if (well_found) {
      wells <- c(wells, raw_dat[i, 1])
      well_found <- FALSE
      data_found <- TRUE
    } else if (data_found && !time_found) {
      time <- raw_dat[i, 2:dim(raw_dat)[2]]
      time_found <- TRUE
    } else if (data_found && str_detect(raw_dat[i, 1], "1;1")) {
      position_od <- c(position_od, i)
      data_found <- FALSE
    }
  }
  wells <- as.character(wells)
  time <- as.numeric(time)

  # compose data frame using information gathered on first traverse
  dat <- tibble(time = time)
  for (j in seq_along(wells)) {
    dat <- dat %>%
      add_column(!!wells[j] := as.numeric(
          raw_dat[position_od[j], 2:dim(raw_dat)[2]]
        )
      )
  }

  return(dat)
}
