
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tecanr <a href="http://www.gl-eb.me/tecanr/"><img src="man/figures/logo.svg" align="right" height="139" alt="tecanr website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/gl-eb/tecanr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/gl-eb/tecanr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

tecanr is an R package to extract data from Excel files generated by
Tecan Infinite 200 Pro plate readers. Currently, only measurements with
multiple reads per well are supported due to differences in the layout
of the data in the spreadsheets.

## Acknowledgements

Tecan® is a trademark of Tecan Group Ltd., Männedorf, Switzerland. The
authors have no affiliation with them other than being users of their
products.

The plate reader icon was designed by
[kehan](https://github.com/kehantan) and is licensed under
[CC0](https://creativecommons.org/publicdomain/zero/1.0/)

## Installation

You can install tecanr from [GitHub](https://github.com/gl-eb/tecanr)
with:

``` r
# install.packages("devtools")
devtools::install_github("gl-eb/tecanr")
```

### Development Version

You can also install the development version. While it may contain
unreleased features, changes or bugfixes, it is also likely to rapidly
evolve, potentially breaking your code. Do not use the development
version if you are not willing to deal with this.

``` r
devtools::install_github("gl-eb/tecanr", ref = "develop")
```

## Hot To Use

Examples of analysis workflows are documented in `vignette("tecanr")`

``` r
library(tecanr)
```

``` r
# parse your own set of measurements
dat <- tecan_parse("path/to/file.xlsx")

# specify sheet of the excel file (default: 1)
dat <- tecan_parse("path/to/file.xlsx", sheet = 3)

# unite multiple segments of a time series of measurements
dat <- tecan_unite("path/to/file.xlsx")

# specify with which sheets to start and how many to include
dat <- tecan_unite("path/to/file.xlsx", segments = 2, start = 1)
```
