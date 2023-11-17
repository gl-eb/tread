# tecan_read_temperature() is deprecated

    Code
      tecan_read_temperature(file_time_series_multiple_reads())
    Condition
      Warning:
      `tecan_read_temperature()` was deprecated in tecanr 0.4.0.
      i This function is a special case of tecan_parse(); use it instead
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

# tecan_read_temperature() still works

    Code
      old <- tidyr::drop_na(tecan_read_temperature(file_time_series_multiple_reads()))
    Condition
      Warning:
      `tecan_read_temperature()` was deprecated in tecanr 0.4.0.
      i This function is a special case of tecan_parse(); use it instead
    Code
      new <- dplyr::mutate(dplyr::rename(dplyr::distinct(dplyr::select(tecan_parse(
        file_time_series_multiple_reads()), time_s, temp_c)), time = time_s,
      temperature = temp_c), time = as.integer(time))
    Message
      i Multiple reads per well detected
      i Time series detected
    Code
      expect_equal(old, new)

