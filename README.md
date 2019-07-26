
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
#>  1 BodySa… c4052f… City go… This dat… Table            WEB,CS… Daily       
#>  2 Street… 1db347… City go… Transit … Map              CSV,GE… Semi-annual…
#>  3 Street… 74f636… City go… Publicat… Map              CSV,GE… Semi-annual…
#>  4 Street… 821fed… City go… Public w… Map              CSV,GE… Semi-annual…
#>  5 Street… ccfdb1… City go… Poster s… Map              CSV,GE… Semi-annual…
#>  6 Street… cf706a… City go… Poster b… Map              CSV,GE… Semi-annual…
#>  7 Street… 99b1f3… City go… Informat… Map              CSV,GE… Semi-annual…
#>  8 Street… 71e6c2… Transpo… "Bike Pa… Map              CSV,GE… Daily       
#>  9 Street… 0c4eb9… City go… Bench lo… Map              CSV,GE… Semi-annual…
#> 10 Polls … 7bce9b… City go… Polls ar… Table            XLSX,C… Daily       
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
#> # A tibble: 1 x 5
#>   name          id             format created      url                     
#>   <chr>         <chr>          <chr>  <chr>        <chr>                   
#> 1 Marriage Lic… 4d985c1d-9c7e… CSV    2019-07-23T… https://ckan0.cf.openda…
```

Finally (and most usefully\!), you can download the resource (i.e., the
actual data) directly into R using `download_resource()`:

``` r
marriage_licence_statistics <- get_resource(
  url = marriage_licence_resources[["url"]],
  format = marriage_licence_resources[["format"]]
)

marriage_licence_statistics
#> # A tibble: 408 x 4
#>     X_id CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <fct>                    <int> <fct>      
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
#> # … with 398 more rows
```
