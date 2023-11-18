if(getRversion() >= "2.15.1")  utils::globalVariables(c(".data"))

#' Stitch together segments of time series measurements
#'
#' Parses a Tecan Infinite 200 Pro plate reader Excel file that contains
#' segments of a time series spread over multiple sheets and automatically
#' stitches them together accounting for the time gap between them
#'
#' @param xlsx_file (character) path to Excel file
#' @param segments (numeric) number of segments to stitch together, starting
#'   from the last sheet (default: number of sheets)
#' @param skip (numeric) number of sheets to skip, starting with the last sheet
#'   (default: 0). Note that empty sheets will be skipped automatically
#'
#' @return A [tibble::tibble()] containing tidy data
#'
#' @examples
#' tecan_unite(
#'   system.file(
#'     "extdata",
#'     "tecan_time_series_segments.xlsx",
#'     package = "tecanr"
#'   )
#' )
#'
#' @export
tecan_unite <- function(xlsx_file, segments = NULL, skip = 0) {
  # check argument type and validity
  if (!(is.character(xlsx_file))) {
    cli::cli_abort(c(
            "{.var xlsx_file} must be a character",
      "x" = "You've supplied a {.cls {class(xlsx_file)}}."
    ))
  }
  if (!is.numeric(skip)) {
    cli::cli_abort(c(
            "{.var skip} must be a number",
      "x" = "You've supplied a {.cls {class(skip)}}."
    ))
  }
  if (skip < 0) {
    cli::cli_abort(c(
            "{.var skip} must be >= 0",
      "x" = "You have set {.var skip} to {skip}"
    ))
  }


  # get number of sheets in xlsx file
  sheets <- readxl::excel_sheets(xlsx_file) |> length()

  # if user does not provide number of segments, use number of sheets
  if (is.null(segments)) {
    segments <- sheets - skip
  }

  # check validity of segments argument
  if (!is.numeric(segments)) {
    cli::cli_abort(c(
            "{.var segments} must be a number",
      "x" = "You've supplied a {.cls {class(segments)}}."
    ))
  }
  if ((segments + skip) > sheets) {
    cli::cli_abort(c(
      paste(
        "{.var segments} + {.var skip} must be smaller or equal to the number",
        "of sheets"
      ),
      "x" = "You provided {.val {segments}} + {.val {skip}} > {.val {sheets}}"
    ))
  } else if (segments < 1) {
    cli::cli_abort(c(
            "{.var segments} must be >= 1",
      "x" = "You set {.var segments = {segments}}"
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

  # set Excel sheet indices and in which order they are read
  # Specifically, we start from the last sheet in the Excel file or from the nth
  # to last one if skip = n. Then we work our way forward (to the left when
  # looking at the file in Excel) until the number of segments has been
  # processed
  indices <- seq(from = sheets - skip, by = -1, length.out = segments)

  # loop through all data-containing sheets
  for (i in seq(segments)) {
    # import excel sheet as a whole to extract starting time and duration
    dat_raw <- readxl::read_xlsx(
          xlsx_file,
          sheet = indices[i],
          col_names = FALSE
      ) |>
      suppressMessages()

    # skip rest of loop if sheet empty
    if (nrow(dat_raw) == 0 | ncol(dat_raw) <= 1) next

    # extract starting time and duration of segment
    col_1 <- names(dat_raw)[1]
    col_2 <- names(dat_raw)[2]
    start_raw <- dat_raw |>
      dplyr::select({{ col_1 }}:{{ col_2 }}) |>
      dplyr::filter(
        .data[[col_1]] == "Date:" |
        .data[[col_1]] == "Time:"
      ) |>
      dplyr::pull({{ col_2 }}) |>
      unique()

    # stop if datetime detection returns anything other than two rows
    if (length(start_raw) != 2) {
      cli::cli_abort(c(
        "x" = "No valid data found in segment {i}"
      ))
    }

    start_datetime <- paste(
        janitor::convert_to_date(start_raw[1]),
        start_raw[2]
      ) |>
      lubridate::ymd_hms()

    # import data starting from the back (# data-segments - current_index + 1)
    dat_sheet <- tecanr::tecan_parse(
        xlsx_file,
        xlsx_sheet = indices[i]
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
        segment = i,
        start = start_datetime,
        duration = segment_duration,
        end = start_datetime + .data$duration
      )

    # if current segment is not the first, add duration of data so far as well
    # as offset to time column
    if (nrow(time_offsets) > 1) {
      # get end datetime of previous segment
      previous_end <- time_offsets |>
        dplyr::filter(.data$segment == i - 1) |>
        dplyr::pull(.data$end)
      current_start <- time_offsets |>
        dplyr::filter(.data$segment == i) |>
        dplyr::pull(.data$start)

      # get the time offset for the current sheet
      current_offset <- lubridate::as.duration(current_start - previous_end)

      if (current_offset < 0) {
        cli::cli_abort(c(
                "Time offsets between segments should be positive",
          "x" = "Time offset between segments {i-1} and {i} is {current_offset}"
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
