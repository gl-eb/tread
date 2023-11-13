if(getRversion() >= "2.15.1")  utils::globalVariables(c(".data"))

#' Stitch together segments of time series measurements
#'
#' Parses a Tecan Infinite 200 Pro plate reader Excel file that contains
#' segments of a time series spread over multiple sheets and automatically
#' stitches them together accounting for the time gap between them
#'
#' @param xlsx_file (character) path to Excel file
#' @param segments (numeric) number of segments to stitch together, starting
#' from the last sheet (default: number of sheets)
#'
#' @return A [tibble::tibble()] containing tidy data
#'
#' @examples
#' dat <- assemble_data_segments(
#'   system.file(
#'     "extdata",
#'     "tecan_time_series_segments.xlsx",
#'     package = "tecanr"
#'   )
#' )
#'
#' @export
assemble_data_segments <- function(xlsx_file, segments = NULL) {
  # get number of sheets in xlsx file
  sheets <- readxl::excel_sheets(xlsx_file) |> length()

  # if user does not provide number of segments, use number of sheets
  if (is.null(segments)) {
    segments <- sheets
  }

  if (!(is.character(xlsx_file))) {
    cli::cli_abort(c(
            "{.var xlsx_file} must be a character",
      "x" = "You've supplied a {.cls {class(xlsx_file)}}."
    ))
  }

  if (segments > sheets) {
    cli::cli_abort(c(
      "x" = "{.var segments} is greater than the number of sheets"
    ))
  }

  # initiate empty tibbles
  dat_ass <- tibble::tibble()
  time_offsets <- tibble::tibble(
    segment = numeric(),
    start = lubridate::ymd_hms(),
    duration = lubridate::duration(),
    end = lubridate::ymd_hms()
  )

  # loop through all data-containing sheets
  for (s in seq(segments)) {
    # import excel sheet as a whole to extract starting time and duration
    dat_raw <- readxl::read_xlsx(
          xlsx_file,
          sheet = segments - s + 1,
          col_names = FALSE
      ) |>
      suppressMessages()

    # skip rest of loop if sheet empty
    if (nrow(dat_raw) == 0) next

    # extract starting time and duration of segment
    col_1 <- names(dat_raw)[1]
    col_2 <- names(dat_raw)[2]
    start_raw <- dat_raw |>
      dplyr::select({{ col_1 }}:{{ col_2 }}) |>
      dplyr::filter(
        .data[[col_1]] == "Date:" |
        .data[[col_1]] == "Time:"
      ) |>
      dplyr::pull({{ col_2 }})
    start_datetime <- paste(
        janitor::convert_to_date(start_raw[1]),
        start_raw[2]
      ) |>
      lubridate::ymd_hms()

    # import data starting from the back (# data-segments - current_index + 1)
    dat_sheet <- tecanr::tecan_parse(
        xlsx_file,
        xlsx_sheet = segments - s + 1
      ) |>
      janitor::clean_names() |>
      dplyr::rename(time = "time_s", temperature = "temp_c")

    # calculate the duration of the current segment
    segment_duration <- dat_sheet |>
      dplyr::pull("time") |>
      as.double() |>
      max(na.rm = TRUE) |>
      lubridate::dseconds()

    # update offsets table
    time_offsets <- time_offsets |>
      tibble::add_row(
        segment = s,
        start = start_datetime,
        duration = segment_duration,
        end = start_datetime + .data$duration
      )

    # if current segment is not the first, add duration of data so far as well
    # as offset to time column
    if (nrow(time_offsets) > 1) {
      # get end datetime of previous segment
      previous_end <- time_offsets |>
        dplyr::filter(.data$segment == s - 1) |>
        dplyr::pull(.data$end)
      current_start <- time_offsets |>
        dplyr::filter(.data$segment == s) |>
        dplyr::pull(.data$start)

      # get the time offset for the current sheet
      current_offset <- lubridate::as.duration(current_start - previous_end)

      # stop if no offset found
      if (rlang::is_empty(current_offset)) {
        cli::cli_abort(c(
          "x" = "No time offset found for data segment {s}"
        ))
      }

      dat_sheet$time <- dat_sheet$time + max(dat_ass$time) + current_offset |>
        as.double()
    }

    # bind current segment to raw data
    dat_ass <- dat_ass |>
      dplyr::bind_rows(dat_sheet) |>
      dplyr::arrange(.data$well, .data$time)
  }

  return(dat_ass)
}
