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
      "x" = "{.var segments} is greater than the number of sheets",
    ))
  }

  # initiate empty tibbles
  dat_raw <- tibble()
  time_offsets <- tibble(
    segment = numeric(),
    start = ymd_hms(),
    duration = duration(),
    end = ymd_hms()
  )

  # loop through all data-containing sheets
  for (s in seq(segments)) {
    # import excel sheet as a whole to extract starting time and duration
    start_raw <- read_xlsx(
        xlsx_file,
        sheet = segments - s + 1,
        col_names = FALSE
    ) |>
      select(1:2) |>
      filter(...1 == "Date:" | ...1 == "Time:") |>
      pull(...2) |>
      suppressMessages()
    start_datetime <- str_glue(
        "{convert_to_date(start_raw[1])} {start_raw[2]}"
      ) |>
      ymd_hms()

    # import data starting from the back (# data-segments - current_index + 1)
    dat_sheet <- tecan_parse(xlsx_file, xlsx_sheet = segments - s + 1)

    # calculate the duration of the current segment
    segment_duration <- dat_sheet |>
      pull(time) |>
      as.double() |>
      max(na.rm = TRUE) |>
      dseconds()

    # update offsets table
    time_offsets <- time_offsets |>
      add_row(
        segment = s,
        start = start_datetime,
        duration = segment_duration,
        end = start_datetime + duration
      )

    # if current segment is not the first, add duration of data so far as well
    # as offset to time column
    if (s > 1) {
      # get end datetime of previous segment
      previous_end <- time_offsets |>
        filter(segment == s - 1) |>
        pull(end)
      current_start <- time_offsets |>
        filter(segment == s) |>
        pull(start)

      # get the time offset for the current sheet
      current_offset <- as.duration(current_start - previous_end)

      # stop if no offset found
      if (is_empty(current_offset)) {
        cli::cli_abort(c(
            "x" = "No time offset found for data segment {segment}"
        ))
      }

      dat_sheet$time <- dat_sheet$time + max(dat_raw$time) + current_offset |>
        as.double()
    }

    # bind current segment to raw data
    dat_raw <- dat_raw |> bind_rows(dat_sheet) |> arrange(well, time)
  }

  return(dat_raw)
}
