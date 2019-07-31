
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
#> # A tibble: 100 x 7
#>    title   id      topics   excerpt   dataset_category formats refresh_rate
#>    <chr>   <chr>   <chr>    <chr>     <chr>            <chr>   <chr>       
#>  1 Street… 74f636… City go… Publicat… Map              CSV,GE… Semi-annual…
#>  2 Street… 1db347… City go… Transit … Map              CSV,GE… Semi-annual…
#>  3 Street… ccfdb1… City go… Poster s… Map              CSV,GE… Semi-annual…
#>  4 Street… 821fed… City go… Public w… Map              CSV,GE… Semi-annual…
#>  5 Chemic… ae8eeb… Environ… This dat… Table            WEB,XL… Daily       
#>  6 Commun… 5709d6… City go… This is … Map              SHP,CS… As available
#>  7 Stillb… 93b2ff… Health   This dat… Table            CSV,JS… Monthly     
#>  8 BodySa… c4052f… City go… This dat… Table            WEB,CS… Daily       
#>  9 Street… cf706a… City go… Poster b… Map              CSV,GE… Semi-annual…
#> 10 Street… 394435… City go… Litter R… Map              CSV,GE… Semi-annual…
#> # … with 90 more rows
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`list_package_resources()`:

``` r
library(dplyr)

marriage_licence_packages <- packages %>%
  filter(title == "Marriage Licence Statistics")

marriage_licence_resources <- list_package_resources(marriage_licence_packages[["id"]])

marriage_licence_resources
#> # A tibble: 1 x 2
#>   name                             id                                  
#>   <chr>                            <chr>                               
#> 1 Marriage Licence Statistics Data 4d985c1d-9c7e-4f74-9864-73214f45eb4a
```

Finally (and most usefully\!), you can download the resource (i.e., the
actual data) directly into R using `download_resource()`:

``` r
marriage_licence_statistics <- get_resource(
  resource_id = marriage_licence_resources[1, ]
)

marriage_licence_statistics
#> # A tibble: 100 x 4
#>    `_id` CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <chr>                    <int> <chr>      
#>  1     1 ET                          80 2011-01    
#>  2     2 NY                         136 2011-01    
#>  3     3 SC                         159 2011-01    
#>  4     4 TO                         367 2011-01    
#>  5     5 ET                         109 2011-02    
#>  6     6 NY                         150 2011-02    
#>  7     7 SC                         154 2011-02    
#>  8     8 TO                         383 2011-02    
#>  9     9 ET                         177 2011-03    
#> 10    10 NY                         231 2011-03    
#> # … with 90 more rows
```
