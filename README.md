
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

- [Introduction to
  `opendatatoronto`](https://sharlagelfand.github.io/opendatatoronto/articles/opendatatoronto.html)
- [Retrieving multi-sheet XLS/XLSX
  resources](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multisheet_resources.html)
- [Retrieving multi-file ZIP
  resources](https://sharlagelfand.github.io/opendatatoronto/articles/articles/multifile_zip_resources.html)
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
#> # A tibble: 10 × 11
#>    title            id    topics civic_issues publisher excerpt dataset_category
#>    <chr>            <chr> <chr>  <chr>        <chr>     <chr>   <chr>           
#>  1 Licensed Dogs a… lice… "Comm… NULL         Municipa… "The r… Table           
#>  2 Multi-Tenant (R… mult… "Perm… NULL         Municipa… "This … Table           
#>  3 Polls conducted… 7bce… "City… NULL         City Cle… "Polls… Table           
#>  4 Rain Gauge Loca… f293… "c(\"… NULL         Toronto … "This … Document        
#>  5 Sidewalk Constr… side… "Tran… NULL         Transpor… "The C… Map             
#>  6 Traffic Signal … 7dda… "Tran… Mobility     Transpor… "This … Document        
#>  7 Daily Shelter &… 21c8… "c(\"… NULL         Toronto … "Daily… Table           
#>  8 Traffic Volumes… traf… "Tran… Mobility     Transpor… "This … Table           
#>  9 Toronto Island … toro… "Tran… NULL         Parks, F… "This … Table           
#> 10 Toronto Open Da… open… "City… NULL         Informat… "This … Table           
#> # ℹ 4 more variables: num_resources <int>, formats <chr>, refresh_rate <chr>,
#> #   last_refreshed <date>
```

You can also search packages by title:

``` r
ttc_packages <- search_packages("ttc")

ttc_packages
#> # A tibble: 15 × 11
#>    title            id    topics civic_issues publisher excerpt dataset_category
#>    <chr>            <chr> <chr>  <chr>        <chr>     <chr>   <chr>           
#>  1 TTC Subway Shap… c01c… "NULL" "NULL"       Toronto … "This … Document        
#>  2 TTC Ridership A… ef35… "Tran… "Mobility"   Toronto … "This … Document        
#>  3 TTC Routes and … 7795… "Tran… "NULL"       Toronto … "Data … Document        
#>  4 TTC Subway Dela… 996c… "Tran… "NULL"       Toronto … "TTC S… Document        
#>  5 TTC Bus Delay D… e271… "Tran… "NULL"       Toronto … "TTC B… Document        
#>  6 TTC Streetcar D… b68c… "Tran… "NULL"       Toronto … "TTC S… Document        
#>  7 TTC BusTime Rea… 31ed… "Tran… "Mobility"   Toronto … "This … Document        
#>  8 TTC Real-Time N… 8217… "Tran… "NULL"       Toronto … "The N… Document        
#>  9 TTC  - Ridershi… 2c4c… "c(\"… "c(\"Fiscal… Toronto … "This … Website         
#> 10 TTC - Monthly R… d2a7… "Tran… "NULL"       Toronto … "This … Website         
#> 11 TTC - Average W… 4b80… "Tran… "NULL"       Toronto … "This … Website         
#> 12 TTC Annual Pass… 1444… "Tran… "Mobility"   Toronto … "This … Website         
#> 13 TTC - Annual Pa… aedd… "Tran… "Mobility"   Toronto … "This … Website         
#> 14 TTC Ridership -… 4eb6… "Tran… "NULL"       Toronto … "This … Document        
#> 15 TTC Ridership -… d9dc… "Tran… "Mobility"   Toronto … "This … Document        
#> # ℹ 4 more variables: num_resources <int>, formats <chr>, refresh_rate <chr>,
#> #   last_refreshed <date>
```

Or see metadata for a specific package:

``` r
show_package("996cfe8d-fb35-40ce-b569-698d51fc683b")
#> # A tibble: 4 × 11
#>   title             id    topics civic_issues publisher excerpt dataset_category
#>   <chr>             <chr> <chr>  <chr>        <chr>     <chr>   <chr>           
#> 1 TTC Subway Delay… 996c… Trans… <NA>         Toronto … TTC Su… Document        
#> 2 TTC Subway Delay… 996c… Trans… <NA>         Toronto … TTC Su… Document        
#> 3 TTC Subway Delay… 996c… Trans… <NA>         Toronto … TTC Su… Document        
#> 4 TTC Subway Delay… 996c… Trans… <NA>         Toronto … TTC Su… Document        
#> # ℹ 4 more variables: num_resources <int>, formats <chr>, refresh_rate <chr>,
#> #   last_refreshed <date>
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
#> 1 Marriage Licence Statistics Data      4d985c1d-9c7e-4f74… CSV    2025-04-01   
#> 2 Marriage Licence Statistics Data.csv  01dff98a-b56b-4237… CSV    2025-04-01   
#> 3 Marriage Licence Statistics Data.xml  41148040-e29d-4a02… XML    2025-04-01   
#> 4 Marriage Licence Statistics Data.json 620da420-89be-4227… JSON   2025-04-01
```

But you can also get a list of resources by using the package’s URL from
the Portal:

``` r
list_package_resources("https://open.toronto.ca/dataset/sexual-health-clinic-locations-hours-and-services/")
#> # A tibble: 2 × 4
#>   name                                                id    format last_modified
#>   <chr>                                               <chr> <chr>  <date>       
#> 1 sexual-health-clinic-locations-hours-and-services-… 7076… XLSX   2019-08-15   
#> 2 Sexual-health-clinic-locations-hours-and-services-… 5af8… XLSX   2019-08-15
```

Finally (and most usefully!), you can download the resource (i.e., the
actual data) directly into R using `get_resource()`:

``` r
marriage_licence_statistics <- marriage_licence_resources %>%
  head(1) %>%
  get_resource()

marriage_licence_statistics
#> # A tibble: 558 × 4
#>    `_id` CIVIC_CENTRE MARRIAGE_LICENSES TIME_PERIOD
#>    <int> <chr>                    <int> <chr>      
#>  1 19231 ET                          80 2011-01    
#>  2 19232 NY                         136 2011-01    
#>  3 19233 SC                         159 2011-01    
#>  4 19234 TO                         367 2011-01    
#>  5 19235 ET                         109 2011-02    
#>  6 19236 NY                         150 2011-02    
#>  7 19237 SC                         154 2011-02    
#>  8 19238 TO                         383 2011-02    
#>  9 19239 ET                         177 2011-03    
#> 10 19240 NY                         231 2011-03    
#> # ℹ 548 more rows
```
