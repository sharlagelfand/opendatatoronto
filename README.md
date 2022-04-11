
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatatoronto <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->

[![R build
status](https://github.com/sharlagelfand/opendatatoronto/workflows/R-CMD-check/badge.svg)](https://github.com/sharlagelfand/opendatatoronto/actions)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/sharlagelfand/opendatatoronto?branch=main&svg=true)](https://ci.appveyor.com/project/sharlagelfand/opendatatoronto)
[![Codecov test
coverage](https://codecov.io/gh/sharlagelfand/opendatatoronto/branch/main/graph/badge.svg)](https://app.codecov.io/gh/sharlagelfand/opendatatoronto?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/opendatatoronto)](https://cran.r-project.org/package=opendatatoronto)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
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

-   [Introduction to
    `opendatatoronto`](https://sharlagelfand.github.io/opendatatoronto/articles/opendatatoronto.html)
-   [Retrieving multi-sheet XLS/XLSX
    resources](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multisheet_resources.html)
-   [Retrieving multi-file ZIP
    resources](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multifile_zip_resources.html)
-   [Retrieving multiple resources using
    `purrr`](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multiple_resources_purrr.html)
-   [Working with spatial data from the
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
#> # A tibble: 10 × 11
#>    title   id      topics    civic_issues  publisher  excerpt   dataset_category
#>    <chr>   <chr>   <chr>     <chr>         <chr>      <chr>     <chr>           
#>  1 Utilit… 43cbc3… Developm… Mobility      Transport… "Locatio… Table           
#>  2 EarlyO… earlyo… Communit… Poverty redu… Children'… "EarlyON… Map             
#>  3 Daily … 21c83b… Communit… Affordable h… Shelter, … "Daily o… Table           
#>  4 Licens… 059d37… Communit… <NA>          Children'… "License… Map             
#>  5 Toront… 59de0a… City gov… <NA>          Economic … "Toronto… Document        
#>  6 Short … 2ab20f… Permits … Affordable h… Municipal… "This da… Table           
#>  7 Polls … 7bce9b… City gov… <NA>          City Cler… "Polls a… Table           
#>  8 Rain G… f29335… Location… Climate chan… Toronto W… "This da… Document        
#>  9 COVID-… d3f21f… Health    <NA>          Toronto P… "This da… Map             
#> 10 COVID-… cd616c… Health    <NA>          Toronto P… "This da… Map             
#> # … with 4 more variables: num_resources <int>, formats <chr>,
#> #   refresh_rate <chr>, last_refreshed <date>
```

You can also search packages by title:

``` r
ttc_packages <- search_packages("ttc")

ttc_packages
#> # A tibble: 14 × 11
#>    title    id      topics  civic_issues  publisher  excerpt    dataset_category
#>    <chr>    <chr>   <chr>   <chr>         <chr>      <chr>      <chr>           
#>  1 TTC Sub… c01c6d… <NA>    Mobility      Toronto T… "This dat… Document        
#>  2 TTC Rou… 7795b4… Transp… Mobility      Toronto T… "Data con… Document        
#>  3 TTC Sub… 996cfe… Transp… Mobility      Toronto T… "TTC Subw… Document        
#>  4 TTC Str… b68cb7… Transp… Mobility      Toronto T… "TTC Stre… Document        
#>  5 TTC Rid… 4eb6a6… Transp… Mobility      Toronto T… "This dat… Document        
#>  6 TTC  - … 2c4c84… Financ… Mobility,Fis… Toronto T… "This dat… Website         
#>  7 TTC Rid… ef35ef… Transp… Mobility      Toronto T… "This dat… Document        
#>  8 TTC Rid… d9dc43… Transp… Mobility      Toronto T… "This dat… Document        
#>  9 TTC Rea… 8217e4… Transp… Mobility      Toronto T… "The NVAS… Document        
#> 10 TTC - M… d2a784… Transp… Mobility      Toronto T… "This dat… Website         
#> 11 TTC Bus… e271cd… Transp… Mobility      Toronto T… "TTC Bus … Document        
#> 12 TTC - A… 4b8090… Transp… Mobility      Toronto T… "This dat… Website         
#> 13 TTC Ann… 144412… Transp… Mobility      Toronto T… "This dat… Website         
#> 14 TTC - A… aeddbf… Transp… Mobility      Toronto T… "This dat… Website         
#> # … with 4 more variables: num_resources <int>, formats <chr>,
#> #   refresh_rate <chr>, last_refreshed <date>
```

Or see metadata for a specific package:

``` r
show_package("996cfe8d-fb35-40ce-b569-698d51fc683b")
#> # A tibble: 1 × 11
#>   title    id         topics  civic_issues publisher   excerpt  dataset_category
#>   <chr>    <chr>      <chr>   <chr>        <chr>       <chr>    <chr>           
#> 1 TTC Sub… 996cfe8d-… Transp… Mobility     Toronto Tr… TTC Sub… Document        
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
#> # A tibble: 4 × 4
#>   name                                  id                  format last_modified
#>   <chr>                                 <chr>               <chr>  <date>       
#> 1 Marriage Licence Statistics Data      4d985c1d-9c7e-4f74… CSV    2022-04-01   
#> 2 Marriage Licence Statistics Data.csv  01dff98a-b56b-4237… CSV    2022-04-01   
#> 3 Marriage Licence Statistics Data.xml  41148040-e29d-4a02… XML    2022-04-01   
#> 4 Marriage Licence Statistics Data.json 620da420-89be-4227… JSON   2022-04-01
```

But you can also get a list of resources by using the package’s URL from
the Portal:

``` r
list_package_resources("https://open.toronto.ca/dataset/sexual-health-clinic-locations-hours-and-services/")
#> # A tibble: 2 × 4
#>   name                               id                     format last_modified
#>   <chr>                              <chr>                  <chr>  <date>       
#> 1 sexual-health-clinic-locations-ho… 70764fa4-281d-4524-bd… XLSX   2019-08-15   
#> 2 Sexual-health-clinic-locations-ho… 5af8d0a3-a8a1-4a2e-ba… XLSX   2019-08-15
```

Finally (and most usefully!), you can download the resource (i.e., the
actual data) directly into R using `get_resource()`:

``` r
marriage_licence_statistics <- marriage_licence_resources %>%
  head(1) %>%
  get_resource()

marriage_licence_statistics
#> # A tibble: 487 × 4
#>    `_id` CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <chr>                    <int> <chr>      
#>  1   487 ET                          80 2011-01    
#>  2   488 NY                         136 2011-01    
#>  3   489 SC                         159 2011-01    
#>  4   490 TO                         367 2011-01    
#>  5   491 ET                         109 2011-02    
#>  6   492 NY                         150 2011-02    
#>  7   493 SC                         154 2011-02    
#>  8   494 TO                         383 2011-02    
#>  9   495 ET                         177 2011-03    
#> 10   496 NY                         231 2011-03    
#> # … with 477 more rows
```
