# tecanr (development version)

- Use citation file format (CFF) in addition to bibtex

# tecanr 0.4.1

- Add citation information and doi badge
- Update author and copyright holder information

# tecanr 0.4.0

- Add `tecan_unite()` for stitching together time series measurements when the plate reader programme was stopped and restarted
- Add `tecan_single_time_single_reads()` and `tecan_time_series_single_reads()`, which allow `tecan_parse()` to deal with all four data formats (all combinations of single or multiple reads per well as well as single timepoint or time series)
- `tecan_parse()` now returns a `tibble::tibble()` with clean column names and correct column types
- Deprecated `tecan_read_temperature()` since it is a special case of `tecan_parse()` and much less flexible in regards to the format of the input file
- Improve documentation and create pkgdown website
- Expand unit testing and use GitHub CI

# tecanr 0.3.2

- Use writeLines() instead of print() to avoid line numbers
- Fixed namespace
- Got around R CMD check note about unused import of utils, which is needed for where()

# tecanr 0.3.1

- Implemented initial version of tecan_parse(), which supports multiple reads per well of single or multiple timepoint OD measurements
- Use renv for package development
- Bug fixes and minor improvements
