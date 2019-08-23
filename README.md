
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

For more information, please visit the [package
website](https://sharlagelfand.github.io/opendatatoronto/) and
vignettes:

  - [Introduction to
    `opendatatoronto`](https://sharlagelfand.github.io/opendatatoronto/articles/opendatatoronto.html)
  - [Retrieving multi-sheet XLS/XLSX
    resources](https://sharlagelfand.github.io/opendatatoronto/articles/multisheet_resources.html)
  - [Retrieving multi-file ZIP
    resources](https://sharlagelfand.github.io/opendatatoronto/articles/multifile_zip_resources.html)
  - [Retrieving multiple resources using
    `purrr`](https://sharlagelfand.github.io/opendatatoronto/articles/multiple_resources_purrr.html)
  - [Working with spatial data from the
    portal](https://sharlagelfand.github.io/opendatatoronto/articles/spatial_data.html)

## Installation

You can install the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("sharlagelfand/opendatatoronto")
```

## Usage

In the Portal, datasets are called **packages**. You can see a list of
available packages by using `list_packages()`:

``` r
library(opendatatoronto)
packages <- list_packages(limit = 100)
packages
#> # A tibble: 100 x 8
#>    title id    topics excerpt dataset_category formats refresh_rate
#>    <chr> <chr> <chr>  <chr>   <chr>            <chr>   <chr>       
#>  1 Apar… 4ef8… Locat… This d… Table            CSV,JS… Annually    
#>  2 311 … 2e54… City … The da… Document         XLSX,Z… Monthly     
#>  3 Body… c405… City … This d… Table            WEB,CS… Daily       
#>  4 Stre… 1db3… City … Transi… Map              CSV,GE… Semi-annual…
#>  5 Stre… 74f6… City … Public… Map              CSV,GE… Semi-annual…
#>  6 Stre… 821f… City … Public… Map              CSV,GE… Semi-annual…
#>  7 Stre… ccfd… City … Poster… Map              CSV,GE… Semi-annual…
#>  8 Stre… cf70… City … Poster… Map              CSV,GE… Semi-annual…
#>  9 Stre… 99b1… City … Inform… Map              CSV,GE… Semi-annual…
#> 10 Stre… 71e6… Trans… "Bike … Map              CSV,GE… Daily       
#> # … with 90 more rows, and 1 more variable: num_resources <int>
```

You can also search packages by title:

``` r
ttc_packages <- search_packages("ttc")

ttc_packages
#> # A tibble: 14 x 8
#>    title id    topics excerpt dataset_category formats refresh_rate
#>    <chr> <chr> <chr>  <chr>   <chr>            <chr>   <chr>       
#>  1 TTC … 996c… Trans… TTC Su… Document         XLSX    Monthly     
#>  2 TTC … b68c… Trans… TTC St… Document         XLSX    Monthly     
#>  3 TTC … e271… Trans… TTC Bu… Document         XLSX    Monthly     
#>  4 TTC … 7795… Trans… Data c… Document         ZIP     Real-time   
#>  5 TTC … 4eb6… Trans… This d… Document         XLSX    Annually    
#>  6 TTC … ef35… Trans… This d… Document         XLSX    Annually    
#>  7 TTC … d9dc… Trans… This d… Document         XLSX    As available
#>  8 TTC … 8217… Trans… The NV… Document         PDF     Real-time   
#>  9 TTC … 1444… Trans… This d… Website          WEB,XLS Quarterly   
#> 10 TTC … d2a7… Trans… This d… Website          WEB,XLS Quarterly   
#> 11 TTC … 4b80… Trans… This d… Website          WEB,XLS Quarterly   
#> 12 TTC … aedd… Trans… This d… Website          WEB,XLS Quarterly   
#> 13 TTC … 2c4c… Finan… This d… Website          WEB,XLS Quarterly   
#> 14 TTC … c01c… <NA>   "This … Document         SHP     As available
#> # … with 1 more variable: num_resources <int>
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`list_package_resources()`. You can pass it the package id (which is
contained in `marriage_license_packages` below):

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

But you can also get a list of resources by using the package’s URL from
the
Portal:

``` r
list_package_resources("https://open.toronto.ca/dataset/sexual-health-clinic-locations-hours-and-services/")
#> # A tibble: 2 x 4
#>   name                        format id                  last_modified     
#>   <chr>                       <chr>  <chr>               <chr>             
#> 1 sexual-health-clinic-locat… XLSX   e958dd45-9426-4298… 2019-08-15T15:56:…
#> 2 Sexual-health-clinic-locat… XLSX   2edcc4a3-c095-4ce3… 2019-08-15T15:56:…
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

Please note that the ‘opendatatoronto’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
