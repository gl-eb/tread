# tread 0.5.2

- Move commonly used checks to functions to avoid code repetition
- Drop `magrittr` pipe dependency

# tread 0.5.1

- Standalone type checks using `rlang`

# tread 0.5.0

- Rename package to tread
- Use citation file format (CFF) in addition to bibtex

# tread 0.4.1

- Add citation information and doi badge
- Update author and copyright holder information

# tread 0.4.0

- Add `tunite()` for stitching together time series measurements when the plate reader programme was stopped and restarted
- Add `single_time_single_reads()` and `time_series_single_reads()`, which allow `tparse()` to deal with all four data formats (all combinations of single or multiple reads per well as well as single timepoint or time series)
- `tparse()` now returns a `tibble::tibble()` with clean column names and correct column types
- Deprecated `tread_temperature()` since it is a special case of `tparse()` and much less flexible in regards to the format of the input file
- Improve documentation and create pkgdown website
- Expand unit testing and use GitHub CI

# tread 0.3.2

- Use writeLines() instead of print() to avoid line numbers
- Fixed namespace
- Got around R CMD check note about unused import of utils, which is needed for where()

# tread 0.3.1

- Implemented initial version of tparse(), which supports multiple reads per well of single or multiple timepoint OD measurements
- Use renv for package development
- Bug fixes and minor improvements
