
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
available packages by using `list_packages()`. This will show metadata
about the package, including what topics (i.e. tags) the package covers,
a description of it, how many resources there are (and their formats),
how often it is is refreshed and when it was last refreshed.

``` r
library(opendatatoronto)
packages <- list_packages(limit = 100)
packages
#> # A tibble: 100 x 9
#>    title id    topics excerpt dataset_category num_resources formats
#>    <chr> <chr> <chr>  <chr>   <chr>                    <int> <chr>  
#>  1 Body… c405… City … This d… Table                        2 WEB,CS…
#>  2 Stre… 1db3… City … Transi… Map                          1 CSV,GE…
#>  3 Stre… 821f… City … Public… Map                          1 CSV,GE…
#>  4 Stre… ccfd… City … Poster… Map                          1 CSV,GE…
#>  5 Stre… 99b1… City … Inform… Map                          1 CSV,GE…
#>  6 Stre… 71e6… Trans… "Bike … Map                          1 CSV,GE…
#>  7 Stre… 0c4e… City … Bench … Map                          1 CSV,GE…
#>  8 Poll… 7bce… City … Polls … Table                        2 XLSX,C…
#>  9 Chem… ae8e… Envir… This d… Table                        3 WEB,XL…
#> 10 Apar… 4ef8… Locat… This d… Table                        1 CSV,JS…
#> # … with 90 more rows, and 2 more variables: refresh_rate <chr>,
#> #   last_refreshed <date>
```

You can also search packages by title:

``` r
ttc_packages <- search_packages("ttc")

ttc_packages
#> # A tibble: 14 x 9
#>    title id    topics excerpt dataset_category num_resources formats
#>    <chr> <chr> <chr>  <chr>   <chr>                    <int> <chr>  
#>  1 TTC … 996c… Trans… TTC Su… Document                    29 XLSX   
#>  2 TTC … b68c… Trans… TTC St… Document                     7 XLSX   
#>  3 TTC … e271… Trans… TTC Bu… Document                     7 XLSX   
#>  4 TTC … 7795… Trans… Data c… Document                     1 ZIP    
#>  5 TTC … 4eb6… Trans… This d… Document                     5 XLSX   
#>  6 TTC … ef35… Trans… This d… Document                     1 XLSX   
#>  7 TTC … d9dc… Trans… This d… Document                     1 XLSX   
#>  8 TTC … 8217… Trans… The NV… Document                     1 PDF    
#>  9 TTC … 1444… Trans… This d… Website                      2 WEB,XLS
#> 10 TTC … d2a7… Trans… This d… Website                      2 WEB,XLS
#> 11 TTC … 4b80… Trans… This d… Website                      2 WEB,XLS
#> 12 TTC … aedd… Trans… This d… Website                      2 WEB,XLS
#> 13 TTC … 2c4c… Finan… This d… Website                      2 WEB,XLS
#> 14 TTC … c01c… <NA>   "This … Document                     1 SHP    
#> # … with 2 more variables: refresh_rate <chr>, last_refreshed <date>
```

Or see metadata for a specific package:

``` r
show_package("996cfe8d-fb35-40ce-b569-698d51fc683b")
#> # A tibble: 1 x 9
#>   title id    topics excerpt dataset_category num_resources formats
#>   <chr> <chr> <chr>  <chr>   <chr>                    <int> <chr>  
#> 1 TTC … 996c… Trans… TTC Su… Document                    29 XLSX   
#> # … with 2 more variables: refresh_rate <chr>, last_refreshed <date>
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
#>   name                      id                         format last_modified
#>   <chr>                     <chr>                      <chr>  <date>       
#> 1 Marriage Licence Statist… 4d985c1d-9c7e-4f74-9864-7… CSV    2019-08-01
```

But you can also get a list of resources by using the package’s URL from
the
Portal:

``` r
list_package_resources("https://open.toronto.ca/dataset/sexual-health-clinic-locations-hours-and-services/")
#> # A tibble: 2 x 4
#>   name                            id                   format last_modified
#>   <chr>                           <chr>                <chr>  <date>       
#> 1 sexual-health-clinic-locations… e958dd45-9426-4298-… XLSX   2019-08-15   
#> 2 Sexual-health-clinic-locations… 2edcc4a3-c095-4ce3-… XLSX   2019-08-15
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
