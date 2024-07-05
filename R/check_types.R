#' Check whether plate reader data was found in Excel spreadsheet
#'
#' @param x First value to check
#' @param y Second value to check
#' @returns NULL
#'
#' @keywords internal
check_data_found <- function(x, y = "") {
  if (rlang::is_empty(x) | rlang::is_empty(y)) {
    cli::cli_abort(c(
      "x" = paste(
        "No data found in the expected format.",
        "Please inspect the Excel sheet carefully"
      )
    ))
  } else {
    return(invisible(NULL))
  }
}

#' Check if file exists
#'
#' @param file Path to file
#' @returns NULL
#'
#' @keywords internal
check_file_exists <- function(file) {
  if (!(fs::file_exists(file))) {
    cli::cli_abort(c(
      "x" = "File does not exist: {.file {xlsx_file}}"
    ))
  } else {
    return(invisible(NULL))
  }
}