
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatatoronto <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->

[![R build
status](https://github.com/sharlagelfand/opendatatoronto/workflows/R-CMD-check/badge.svg)](https://github.com/sharlagelfand/opendatatoronto/actions)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/sharlagelfand/opendatatoronto?branch=main&svg=true)](https://ci.appveyor.com/project/sharlagelfand/opendatatoronto)
[![Codecov test
coverage](https://codecov.io/gh/sharlagelfand/opendatatoronto/branch/main/graph/badge.svg)](https://codecov.io/gh/sharlagelfand/opendatatoronto?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/opendatatoronto)](https://cran.r-project.org/package=opendatatoronto)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
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
    resources](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multisheet_resources.html)
  - [Retrieving multi-file ZIP
    resources](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multifile_zip_resources.html)
  - [Retrieving multiple resources using
    `purrr`](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multiple_resources_purrr.html)
  - [Working with spatial data from the
    portal](https://sharlagelfand.github.io/opendatatoronto/articles/articles/spatial_data.html)

## Installation

You can intall the released version of opendatatoronto from CRAN:

``` r
install.packages("opendatatoronto")
```

or the development version from GitHub with:

``` r
devtools::install_github("sharlagelfand/opendatatoronto", ref = "main")
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
#> # A tibble: 10 x 11
#>    title id    topics civic_issues publisher excerpt dataset_category
#>    <chr> <chr> <chr>  <chr>        <chr>     <chr>   <chr>           
#>  1 Cata… 473d… City … <NA>         Informat… Histor… Table           
#>  2 Lobb… 6a87… City … <NA>         Lobbyist… The Lo… Document        
#>  3 Addr… abed… Locat… Mobility     Informat… This d… Document        
#>  4 Prop… 1aca… Locat… Mobility     Informat… This d… Document        
#>  5 Buil… 108c… Devel… Affordable … Toronto … Provid… Document        
#>  6 Buil… 8219… Devel… <NA>         Toronto … Provid… Document        
#>  7 Muni… 5da2… City … Affordable … Municipa… This d… Document        
#>  8 Shor… fc41… Permi… Affordable … Municipa… This d… Table           
#>  9 Poll… 7bce… City … <NA>         City Cle… Polls … Table           
#> 10 Dail… 8a6e… City … Affordable … Shelter,… Daily … Table           
#> # … with 4 more variables: num_resources <int>, formats <chr>,
#> #   refresh_rate <chr>, last_refreshed <date>
```

You can also search packages by title:

``` r
ttc_packages <- search_packages("ttc")

ttc_packages
#> # A tibble: 14 x 11
#>    title id    topics civic_issues publisher excerpt dataset_category
#>    <chr> <chr> <chr>  <chr>        <chr>     <chr>   <chr>           
#>  1 TTC … 7795… Trans… Mobility     Toronto … "Data … Document        
#>  2 TTC … 996c… Trans… Mobility     Toronto … "TTC S… Document        
#>  3 TTC … b68c… Trans… Mobility     Toronto … "TTC S… Document        
#>  4 TTC … e271… Trans… Mobility     Toronto … "TTC B… Document        
#>  5 TTC … ef35… Trans… Mobility     Toronto … "This … Document        
#>  6 TTC … aedd… Trans… Mobility     Toronto … "This … Website         
#>  7 TTC … 1444… Trans… Mobility     Toronto … "This … Website         
#>  8 TTC … 4b80… Trans… Mobility     Toronto … "This … Website         
#>  9 TTC … d2a7… Trans… Mobility     Toronto … "This … Website         
#> 10 TTC … d9dc… Trans… Mobility     Toronto … "This … Document        
#> 11 TTC … 2c4c… Finan… Mobility,Fi… Toronto … "This … Website         
#> 12 TTC … 4eb6… Trans… Mobility     Toronto … "This … Document        
#> 13 TTC … c01c… <NA>   Mobility     Toronto … "This … Document        
#> 14 TTC … 8217… Trans… Mobility     Toronto … "The N… Document        
#> # … with 4 more variables: num_resources <int>, formats <chr>,
#> #   refresh_rate <chr>, last_refreshed <date>
```

Or see metadata for a specific package:

``` r
show_package("996cfe8d-fb35-40ce-b569-698d51fc683b")
#> # A tibble: 1 x 11
#>   title id    topics civic_issues publisher excerpt dataset_category
#>   <chr> <chr> <chr>  <chr>        <chr>     <chr>   <chr>           
#> 1 TTC … 996c… <NA>   <NA>         <NA>      <NA>    <NA>            
#> # … with 4 more variables: num_resources <int>, formats <chr>,
#> #   refresh_rate <chr>, last_refreshed <date>
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`list_package_resources()`. You can pass it the package id (which is
contained in `marriage_license_packages` below):

``` r
marriage_licence_packages <- search_packages("Marriage Licence Statistics")

marriage_licence_resources <- marriage_licence_packages %>%
  list_package_resources()

marriage_licence_resources
#> # A tibble: 1 x 4
#>   name                        id                            format last_modified
#>   <chr>                       <chr>                         <chr>  <date>       
#> 1 Marriage Licence Statistic… 4d985c1d-9c7e-4f74-9864-7321… CSV    2021-01-01
```

But you can also get a list of resources by using the package’s URL from
the Portal:

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
#> # A tibble: 461 x 4
#>    `_id` CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <chr>                    <dbl> <chr>      
#>  1  8354 ET                          80 2011-01    
#>  2  8355 NY                         136 2011-01    
#>  3  8356 SC                         159 2011-01    
#>  4  8357 TO                         367 2011-01    
#>  5  8358 ET                         109 2011-02    
#>  6  8359 NY                         150 2011-02    
#>  7  8360 SC                         154 2011-02    
#>  8  8361 TO                         383 2011-02    
#>  9  8362 ET                         177 2011-03    
#> 10  8363 NY                         231 2011-03    
#> # … with 451 more rows
```
