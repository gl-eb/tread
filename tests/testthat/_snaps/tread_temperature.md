# tread_temperature() is deprecated

    Code
      tread_temperature(file_time_series_multiple_reads())
    Condition
      Warning:
      `tread_temperature()` was deprecated in tread 0.4.0.
      i This function is a special case of tparse(); use it instead
    Output
      # A tibble: 25 x 2
          time temperature
         <int>       <dbl>
       1     0        30.6
       2   600        30.3
       3  1200        30.6
       4  1800        30.7
       5  2400        30.5
       6  3000        30.5
       7  3600        30.3
       8  4200        30.4
       9  4800        30.5
      10  5400        30.6
      # i 15 more rows

# tread_temperature() still works

    Code
      old <- tidyr::drop_na(tread_temperature(file_time_series_multiple_reads()))
    Condition
      Warning:
      `tread_temperature()` was deprecated in tread 0.4.0.
      i This function is a special case of tparse(); use it instead
    Code
      new <- dplyr::mutate(dplyr::rename(dplyr::distinct(dplyr::select(tparse(
        file_time_series_multiple_reads()), time, temp)), temperature = temp), time = as.integer(
        time))
    Message
      i Multiple reads per well detected
      i Time series detected
    Code
      expect_equal(old, new)

