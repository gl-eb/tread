#' Get time series of temperature values
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' [tread_temperature()] was deprecated because it only supported one type
#' of data (time series with multiple readings per well) and the same result can
#' be achieved with [tparse()]
#'
#' @param xlsx_file (character) path to Excel file
#' @param xlsx_sheet (numeric) index of Excel sheet to read (default: 1)
#'
#' @return A [tibble::tibble()] containing tidy data
#'
#' @examples
#' tread_temperature(
#'   system.file(
#'     "extdata",
#'     "time_series_multiple_reads.xlsx",
#'     package = "tread"
#'   )
#' )
#' # ->
#' tparse(
#'   system.file(
#'     "extdata",
#'     "time_series_multiple_reads.xlsx",
#'     package = "tread"
#'   )
#' ) |>
#' dplyr::select(time, temp) |>
#' dplyr::distinct()
#'
#' @keywords internal
#'
#' @export
tread_temperature <- function(xlsx_file, xlsx_sheet = 1) {
  lifecycle::deprecate_warn(
    "0.4.0",
    "tread_temperature()",
    details = "This function is a special case of tparse(); use it instead"
  )

  # set options within the scope of this function
  withr::local_options(list(rlib_name_repair_verbosity = "quiet"))

  # check function arguments for validity
  check_character(xlsx_file)
  check_number_whole(xlsx_sheet)

  xlsx_file <- xlsx_file |> fs::as_fs_path()

  if (!(fs::file_exists(xlsx_file))) {
    cli::cli_abort(c(
      "x" = "File does not exist: {.file {xlsx_file}}"
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
