## code to prepare `dat_list` dataset goes here

xlsx_file_1 <- "single_time_single_reads.xlsx"
xlsx_path_1 <- system.file("extdata", xlsx_file_1, package = "tread")
dat_raw_1 <- readxl::read_xlsx(xlsx_path_1, sheet = 1, col_names = FALSE)

xlsx_file_2 <- "single_time_multiple_reads.xlsx"
xlsx_path_2 <- system.file("extdata", xlsx_file_2, package = "tread")
dat_raw_2 <- readxl::read_xlsx(xlsx_path_2, sheet = 1, col_names = FALSE)

xlsx_file_3 <- "time_series_single_reads.xlsx"
xlsx_path_3 <- system.file("extdata", xlsx_file_3, package = "tread")
dat_raw_3 <- readxl::read_xlsx(xlsx_path_3, sheet = 1, col_names = FALSE)

xlsx_file_4 <- "time_series_multiple_reads.xlsx"
xlsx_path_4 <- system.file("extdata", xlsx_file_4, package = "tread")
dat_raw_4 <- readxl::read_xlsx(xlsx_path_4, sheet = 1, col_names = FALSE)

traw <- list(
  "single_time_single_reads" = dat_raw_1,
  "single_time_multiple_reads" = dat_raw_2,
  "time_series_single_reads" = dat_raw_3,
  "time_series_multiple_reads" = dat_raw_4
)

usethis::use_data(traw, overwrite = TRUE)
