#' Reads a single-timepoint measurement from a tecan plate reader excel file
#'
#' @param xlsx_file path to Excel file
#' @param xlsx_sheet number of Excel sheet to read (default: 1)
#'
#' @return (tibble) long format data
#'
#' @import tibble
#' @importFrom janitor row_to_names
#' @importFrom magrittr %>%
#' @importFrom readxl read_xlsx
#' @importFrom stringr str_detect
#'
#' @examples
#' tecan_read_single(system.file("extdata", "tecan_single.xlsx", package = "tecanr"))
#'
#' @export
tecan_read_single <- function(xlsx_file, xlsx_sheet = 1) {
  # check parameters for validity
  if (!(is.character(xlsx_file))) {
    stop("File path must be a non empty character")
  }
  if (!(is.numeric(xlsx_sheet))) {
    stop("Sheet number must be numeric")
  }

  # import temperature readings
  raw_dat <- readxl::read_xlsx(xlsx_file, sheet = xlsx_sheet, col_names = F)

  # initialize variables and vectors for data search
  data_start <- numeric()
  data_end <- numeric()

  # iterate through rows and extract data
  for (i in 1:dim(raw_dat)[1]) {
    if (is.na(raw_dat[i, 1])) {
      if (length(data_start) > 0 && length(data_end) == 0) {
        data_end <- i - 1
      }
    } else if (stringr::str_detect(raw_dat[i, 1], "^Well$")) {
      data_start <- i
    }
  }

  # compose data frame using information gathered on first traverse
  dat <- raw_dat[data_start:data_end, 1:8] %>%
    janitor::row_to_names(row_number = 1)

  return(dat)
}
