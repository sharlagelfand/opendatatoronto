
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatatoronto

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/sharlagelfand/opendatatoronto.svg?branch=master)](https://travis-ci.org/sharlagelfand/opendatatoronto)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/sharlagelfand/opendatatoronto?branch=master&svg=true)](https://ci.appveyor.com/project/sharlagelfand/opendatatoronto)
[![Codecov test
coverage](https://codecov.io/gh/sharlagelfand/opendatatoronto/branch/master/graph/badge.svg)](https://codecov.io/gh/sharlagelfand/opendatatoronto?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/opendatatoronto)](https://cran.r-project.org/package=opendatatoronto)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

`opendatatoronto` is an R interface to the [City of Toronto Open Data
Portal](https://portal0.cf.opendata.inter.sandbox-toronto.ca/). The goal
of the package is to help read data directly into R without needing to
manually download it via the portal.

## Installation

You can install the development version from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("sharlagelfand/opendatatoronto")
```

## Example

In the Portal, datasets are called **packages**. You can see a list of
available packages by using `list_packages()`:

``` r
library(opendatatoronto)
packages <- list_packages(limit = 100)
packages
#> # A tibble: 100 x 8
#>    title id    topics excerpt dataset_category formats refresh_rate
#>    <chr> <chr> <chr>  <chr>   <chr>            <chr>   <chr>       
#>  1 Body… c405… City … This d… Table            WEB,CS… Daily       
#>  2 Stre… 1db3… City … Transi… Map              CSV,GE… Semi-annual…
#>  3 Stre… 74f6… City … Public… Map              CSV,GE… Semi-annual…
#>  4 Stre… 821f… City … Public… Map              CSV,GE… Semi-annual…
#>  5 Stre… ccfd… City … Poster… Map              CSV,GE… Semi-annual…
#>  6 Stre… cf70… City … Poster… Map              CSV,GE… Semi-annual…
#>  7 Stre… 99b1… City … Inform… Map              CSV,GE… Semi-annual…
#>  8 Stre… 71e6… Trans… "Bike … Map              CSV,GE… Daily       
#>  9 Stre… 0c4e… City … Bench … Map              CSV,GE… Semi-annual…
#> 10 Poll… 7bce… City … Polls … Table            XLSX,C… Daily       
#> # … with 90 more rows, and 1 more variable: num_resources <int>
```

You can also search packages by title:

``` r
ttc_packages <- search_packages("ttc")

ttc_packages
#> # A tibble: 10 x 8
#>    title id    topics excerpt dataset_category formats refresh_rate
#>    <chr> <chr> <chr>  <chr>   <chr>            <chr>   <chr>       
#>  1 TTC … 996c… Trans… TTC Su… Document         XLSX    Monthly     
#>  2 TTC … b68c… Trans… TTC St… Document         XLSX    Monthly     
#>  3 TTC … 7795… Trans… Data c… Document         ZIP     Real-time   
#>  4 TTC … 4eb6… Trans… This d… Document         XLSX    Annually    
#>  5 TTC … ef35… Trans… This d… Document         XLSX    Annually    
#>  6 TTC … d9dc… Trans… This d… Document         XLSX    As available
#>  7 TTC … 8217… Trans… The NV… Document         PDF     Real-time   
#>  8 TTC … e271… Trans… TTC Bu… Document         XLSX    Monthly     
#>  9 TTC … 1444… Trans… This d… Website          WEB,XLS Quarterly   
#> 10 TTC … d2a7… Trans… This d… Website          WEB,XLS Quarterly   
#> # … with 1 more variable: num_resources <int>
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`list_package_resources()`:

``` r
library(dplyr)

marriage_licence_packages <- packages %>%
  filter(title == "Marriage Licence Statistics")

marriage_licence_resources <- marriage_licence_packages %>%
  list_package_resources()

marriage_licence_resources
#> # A tibble: 1 x 4
#>   name                  format id                      last_modified       
#>   <chr>                 <chr>  <chr>                   <chr>               
#> 1 Marriage Licence Sta… CSV    4d985c1d-9c7e-4f74-986… 2019-08-01T10:10:02…
```

Finally (and most usefully\!), you can download the resource (i.e., the
actual data) directly into R using `get_resource()`:

``` r
marriage_licence_statistics <- marriage_licence_resources %>%
  get_resource()

marriage_licence_statistics
#> # A tibble: 412 x 4
#>    `_id` CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <chr>                    <int> <chr>      
#>  1   409 ET                          80 2011-01    
#>  2   410 NY                         136 2011-01    
#>  3   411 SC                         159 2011-01    
#>  4   412 TO                         367 2011-01    
#>  5   413 ET                         109 2011-02    
#>  6   414 NY                         150 2011-02    
#>  7   415 SC                         154 2011-02    
#>  8   416 TO                         383 2011-02    
#>  9   417 ET                         177 2011-03    
#> 10   418 NY                         231 2011-03    
#> # … with 402 more rows
```
