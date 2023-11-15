# tecanr (development version)

- Add `tecan_unite()` for stitching together time series measurements when the plate reader programme was stopped and restarted
- `tecan_parse()` now returns a `tibble::tibble()` with clean column names and correct column types
- Deprecated `tecan_read_temperature()` since it is a special case of `tecan_parse()` and much less flexible in regards to the format of the input file
- Create pkgdown website
- Enable GitHub CI
- Expand unit testing
- Generate README from Rmarkdown document
- Import tidyselect now that `where()` is exported
- Use fs functions such as `fs::file_exists()` for argument validation
- Use cli functions such as `cli::cli_abort()` for messaging
- Improvements to documentation
- Fix automated testing
- Hide messages telling the user that column names were automatically repaired

# tecanr 0.3.2

- Use writeLines() instead of print() to avoid line numbers
- Fixed namespace
- Got around R CMD check note about unused import of utils, which is needed for where()

# tecanr 0.3.1

- Implemented initial version of tecan_parse(), which supports multiple reads per well of single or multiple timepoint OD measurements
- Use renv for package development
- Bug fixes and minor improvements
