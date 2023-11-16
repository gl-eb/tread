#' Parse a Tecan Infinite 200 Pro plate reader file
#'
#' [tecan_parse()] reads data from a the Excel file produced by a Tecan
#' Infinite 200 Pro plate reader. It automatically determines the type of
#' measurement (single time point or time series, single or multiple reads
#' per well) and will handle the data appropriately.
#'
#' @param xlsx_file (character) path to Excel file
#' @param xlsx_sheet (numeric) index of Excel sheet to read from (default: 1)
#'
#' @return A [tibble::tibble()] containing tidy data
#'
#' @examples
#' dat <- tecan_parse(
#'   system.file(
#'     "extdata",
#'     "tecan_time_series_multi_reads.xlsx",
#'     package = "tecanr"
#'   )
#' )
#'
#' @export
tecan_parse <- function(xlsx_file, xlsx_sheet = 1) {
  # set options within the scope of this function
  withr::local_options(list(rlib_name_repair_verbosity = "quiet"))

  # check function arguments for validity

  if (!(is.character(xlsx_file))) {
    cli::cli_abort(c(
            "{.var xlsx_file} must be a character",
      "x" = "You've supplied a {.cls {class(xlsx_file)}}."
    ))
  }

  xlsx_file <- xlsx_file |> fs::as_fs_path()

  if (!(fs::file_exists(xlsx_file))) {
    cli::cli_abort(c(
      "x" = "File does not exist: {.file {xlsx_file}}"
    ))
  }
  if (!(is.numeric(xlsx_sheet))) {
    cli::cli_abort(c(
            "{.var xlsx_sheet} must be numeric",
      "x" = "You've supplied a {.cls {class(xlsx_sheet)}}."
    ))
  }

  # import data from excel spreadsheet
  dat_raw <- readxl::read_xlsx(xlsx_file, sheet = xlsx_sheet, col_names = FALSE)

  # initialize variables and vectors for data search
  multiple_reads <- FALSE
  time_series <- FALSE

  # iterate through rows to detect data format
  for (i in seq_len(dim(dat_raw)[1])) {
    if (is.na(dat_raw[i, 1])) {
      # skip row if empty
      next
    } else if (stringr::str_detect(dat_raw[i, 1], "Multiple Reads") &&
               multiple_reads == FALSE) {
      # detect if multiple reads per well were taken
      multiple_reads <- TRUE
      cli::cli_inform(c("i" = "Multiple reads per well detected"))
    } else if (stringr::str_detect(dat_raw[i, 1], "Cycle")) {
      # detect if measurements are time series
      time_series <- TRUE
      cli::cli_inform(c("i" = "Time series detected"))
    } else if (multiple_reads && time_series) {
      break
    }
  }

  # call correct function to extract data
  if (multiple_reads) {
    # if multiple reads per well were taken
    if (time_series) {
      # if data is time series of multiple reads per well
      dat <- tecan_time_series_multiple_reads(dat_raw)
    } else {
      # if data is from single time point but multiple reads per well
      dat <- tecan_single_time_multiple_reads(dat_raw)
    }
  } else {
    # if single read per well was taken
    cli::cli_warn(c("!" = "Single reads per well are not supported currently"))
    if (time_series) {
      # if data is time series of single reads per well
      dat <- tecan_time_series_single_reads(dat_raw)
    } else {
      # if data is from single time point and a single read per well
    }
  }

  dat <- dat |> janitor::clean_names()

  return(dat)
}
