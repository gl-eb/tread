#' Raw data for conversion to long format
#'
#' Four datasets of Tecan Infinite 200 Pro runs that use different combinations
#' of two parameters: single timepoint measurement or timeseries of measurements
#' and single or multiple reads per well
#'
#' @format A list of four tibbles
#' \describe{
#'   \item{dat_raw_1}{single timepoint and single read per well}
#'   \item{dat_raw_2}{single timepoint and multiple reads per well}
#'   \item{dat_raw_3}{timeseries and single read per well}
#'   \item{dat_raw_4}{timeseries and multiple reads per well}
#' }
#' @source Gleb Ebert
"traw"
