# tecan_time_series_single_reads produces reproducible results

    Code
      tecan_time_series_single_reads(tecan_raw$time_series_single_reads)
    Output
      # A tibble: 45 x 5
         well  `Cycle Nr.` `Time [s]` `Temp. [°C]`  value
         <chr>       <dbl>      <dbl>        <dbl>  <dbl>
       1 A1              1          0         29.7 0.0947
       2 A2              1          0         29.7 0.144 
       3 A3              1          0         29.7 0.118 
       4 B1              1          0         29.7 0.137 
       5 B2              1          0         29.7 0.141 
       6 B3              1          0         29.7 0.389 
       7 C1              1          0         29.7 0.188 
       8 C2              1          0         29.7 0.173 
       9 C3              1          0         29.7 0.220 
      10 A1              2         10         29.6 0.0951
      # i 35 more rows

