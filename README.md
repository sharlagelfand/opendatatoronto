
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatatoronto <img src="man/figures/logo.png" align="right" height="139" />

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
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/grand-total/opendatatoronto?color=blue)](https://r-pkg.org/pkg/opendatatoronto)
<!-- badges: end -->

`opendatatoronto` is an R interface to the [City of Toronto Open Data
Portal](https://open.toronto.ca/). The goal of the package is to help
read data directly into R without needing to manually download it via
the portal.

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

You can intall the released version of opendatatoronto from CRAN:

``` r
install.packages("opendatatoronto")
```

or the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("sharlagelfand/opendatatoronto")
```

## Usage

In the Portal, datasets are called **packages**. You can see a list of
available packages by using `list_packages()`. This will show metadata
about the package, including what topics (i.e. tags) the package covers,
any civic issues it addresses, a description of it, how many resources
there are (and their formats), how often it is is refreshed and when it
was last refreshed.

``` r
library(opendatatoronto)
packages <- list_packages(limit = 10)
packages
#> # A tibble: 10 x 10
#>    title id    topics civic_issues excerpt dataset_category num_resources
#>    <chr> <chr> <chr>  <chr>        <chr>   <chr>                    <int>
#>  1 Body… c405… City … <NA>         "This … Table                        2
#>  2 Stre… 1db3… City … Mobility     "Trans… Map                          1
#>  3 Stre… 74f6… City … <NA>         "Publi… Map                          1
#>  4 Stre… 821f… City … <NA>         "Publi… Map                          1
#>  5 Stre… ccfd… City … <NA>         "Poste… Map                          1
#>  6 Stre… cf70… City … <NA>         "Poste… Map                          1
#>  7 Stre… 3944… City … <NA>         "Litte… Map                          1
#>  8 Stre… 99b1… City … <NA>         "Infor… Map                          1
#>  9 Stre… 71e6… Trans… <NA>         "Bike … Map                          1
#> 10 Stre… 0c4e… City … <NA>         "Bench… Map                          1
#> # … with 3 more variables: formats <chr>, refresh_rate <chr>,
#> #   last_refreshed <date>
```

You can also search packages by title:

``` r
ttc_packages <- search_packages("ttc")

ttc_packages
#> # A tibble: 14 x 10
#>    title id    topics civic_issues excerpt dataset_category num_resources
#>    <chr> <chr> <chr>  <chr>        <chr>   <chr>                    <int>
#>  1 TTC … 996c… Trans… Mobility     "TTC S… Document                    35
#>  2 TTC … b68c… Trans… Mobility     "TTC S… Document                     7
#>  3 TTC … e271… Trans… Mobility     "TTC B… Document                     7
#>  4 TTC … aedd… Trans… Mobility     "This … Website                      2
#>  5 TTC … 1444… Trans… Mobility     "This … Website                      2
#>  6 TTC … 4b80… Trans… Mobility     "This … Website                      2
#>  7 TTC … d2a7… Trans… Mobility     "This … Website                      2
#>  8 TTC … d9dc… Trans… Mobility     "This … Document                     1
#>  9 TTC … ef35… Trans… Mobility     "This … Document                     1
#> 10 TTC … 2c4c… Finan… Mobility,Fi… "This … Website                      2
#> 11 TTC … 4eb6… Trans… Mobility     "This … Document                     5
#> 12 TTC … c01c… <NA>   Mobility     "This … Document                     1
#> 13 TTC … 7795… Trans… Mobility     "Data … Document                     1
#> 14 TTC … 8217… Trans… Mobility     "The N… Document                     1
#> # … with 3 more variables: formats <chr>, refresh_rate <chr>,
#> #   last_refreshed <date>
```

Or see metadata for a specific package:

``` r
show_package("996cfe8d-fb35-40ce-b569-698d51fc683b")
#> # A tibble: 1 x 10
#>   title id    topics civic_issues excerpt dataset_category num_resources formats
#>   <chr> <chr> <chr>  <chr>        <chr>   <chr>                    <int> <chr>  
#> 1 TTC … 996c… Trans… Mobility     TTC Su… Document                    35 XLSX   
#> # … with 2 more variables: refresh_rate <chr>, last_refreshed <date>
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`list_package_resources()`. You can pass it the package id (which is
contained in `marriage_license_packages`
below):

``` r
marriage_licence_packages <- search_packages("Marriage Licence Statistics")

marriage_licence_resources <- marriage_licence_packages %>%
  list_package_resources()

marriage_licence_resources
#> # A tibble: 1 x 4
#>   name                        id                            format last_modified
#>   <chr>                       <chr>                         <chr>  <date>       
#> 1 Marriage Licence Statistic… 4d985c1d-9c7e-4f74-9864-7321… CSV    2020-02-01
```

But you can also get a list of resources by using the package’s URL from
the
Portal:

``` r
list_package_resources("https://open.toronto.ca/dataset/sexual-health-clinic-locations-hours-and-services/")
#> # A tibble: 2 x 4
#>   name                               id                     format last_modified
#>   <chr>                              <chr>                  <chr>  <date>       
#> 1 sexual-health-clinic-locations-ho… e958dd45-9426-4298-ac… XLSX   2019-08-15   
#> 2 Sexual-health-clinic-locations-ho… 2edcc4a3-c095-4ce3-b0… XLSX   2019-08-15
```

Finally (and most usefully\!), you can download the resource (i.e., the
actual data) directly into R using `get_resource()`:

``` r
marriage_licence_statistics <- marriage_licence_resources %>%
  get_resource()

marriage_licence_statistics
#> # A tibble: 436 x 4
#>    `_id` CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <chr>                    <int> <chr>      
#>  1  2941 ET                          80 2011-01    
#>  2  2942 NY                         136 2011-01    
#>  3  2943 SC                         159 2011-01    
#>  4  2944 TO                         367 2011-01    
#>  5  2945 ET                         109 2011-02    
#>  6  2946 NY                         150 2011-02    
#>  7  2947 SC                         154 2011-02    
#>  8  2948 TO                         383 2011-02    
#>  9  2949 ET                         177 2011-03    
#> 10  2950 NY                         231 2011-03    
#> # … with 426 more rows
```
