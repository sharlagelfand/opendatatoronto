
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatatoronto

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/sharlagelfand/opendatatoronto.svg?branch=master)](https://travis-ci.org/sharlagelfand/opendatatoronto)
[![Codecov test
coverage](https://codecov.io/gh/sharlagelfand/opendatatoronto/branch/master/graph/badge.svg)](https://codecov.io/gh/sharlagelfand/opendatatoronto?branch=master)
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
available packages by using `get_packages()`:

``` r
library(opendatatoronto)
packages <- get_packages(limit = 50)
packages
#> # A tibble: 50 x 7
#>    title   id      topics   excerpt   dataset_category formats refresh_rate
#>    <chr>   <chr>   <chr>    <chr>     <chr>            <list>  <chr>       
#>  1 Chemic… c3729f… Environ… This dat… Website          <chr [… Daily       
#>  2 BodySa… 5eaa37… City go… This dat… Table            <chr [… Daily       
#>  3 Street… c7934f… City go… Transit … Map              <chr [… Semi-annual…
#>  4 Street… 586a1e… City go… Publicat… Map              <chr [… Semi-annual…
#>  5 Street… 1021a7… City go… Public w… Map              <chr [… Semi-annual…
#>  6 Street… 8af26e… City go… Poster s… Map              <chr [… Semi-annual…
#>  7 Street… e85c1a… City go… Poster b… Map              <chr [… Semi-annual…
#>  8 Street… 6ed67d… City go… Litter R… Map              <chr [… Semi-annual…
#>  9 Street… e33453… City go… Informat… Map              <chr [… Semi-annual…
#> 10 Street… 024155… Transpo… "Bike Pa… Map              <chr [… Daily       
#> # … with 40 more rows
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`get_package_resources()`:

``` r
library(dplyr)

marriage_licence_packages <- packages %>%
  filter(title == "Marriage Licence Statistics")

marriage_licence_resources <- get_package_resources(marriage_licence_packages[["id"]])

marriage_licence_resources
#> # A tibble: 1 x 5
#>   name          id             format created      url                     
#>   <chr>         <chr>          <chr>  <chr>        <chr>                   
#> 1 Marriage Lic… dd2c2891-c489… CSV    2019-02-19T… https://ckan0.cf.openda…
```

Finally (and most usefully\!), you can download the resource (i.e., the
actual data) directly into R using `download_resource()`:

``` r
marriage_licence_statistics <- download_resource(
  url = marriage_licence_resources[["url"]],
  format = marriage_licence_resources[["format"]]
)

marriage_licence_statistics
#> # A tibble: 408 x 4
#>     X_id CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <fct>                    <int> <fct>      
#>  1 20993 ET                          80 2011-01    
#>  2 20994 NY                         136 2011-01    
#>  3 20995 SC                         159 2011-01    
#>  4 20996 TO                         367 2011-01    
#>  5 20997 ET                         109 2011-02    
#>  6 20998 NY                         150 2011-02    
#>  7 20999 SC                         154 2011-02    
#>  8 21000 TO                         383 2011-02    
#>  9 21001 ET                         177 2011-03    
#> 10 21002 NY                         231 2011-03    
#> # … with 398 more rows
```
