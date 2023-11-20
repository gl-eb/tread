#' Get time series of temperature values
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' [tecan_read_temperature()] was deprecated because it only supported one type
#' of data (time series with multiple readings per well) and the same result can
#' be achieved with [tecan_parse()]
#'
#' @param xlsx_file (character) path to Excel file
#' @param xlsx_sheet (numeric) index of Excel sheet to read (default: 1)
#'
#' @return A [tibble::tibble()] containing tidy data
#'
#' @examples
#' tecan_read_temperature(
#'   system.file(
#'     "extdata",
#'     "tecan_time_series_multiple_reads.xlsx",
#'     package = "tecanr"
#'   )
#' )
#' # ->
#' tecan_parse(
#'   system.file(
#'     "extdata",
#'     "tecan_time_series_multiple_reads.xlsx",
#'     package = "tecanr"
#'   )
#' ) |>
#' dplyr::select(time, temp) |>
#' dplyr::distinct()
#'
#' @keywords internal
#'
#' @export
tecan_read_temperature <- function(xlsx_file, xlsx_sheet = 1) {
  lifecycle::deprecate_warn(
    "0.4.0",
    "tecan_read_temperature()",
    details = "This function is a special case of tecan_parse(); use it instead"
  )

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
