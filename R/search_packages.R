#' Search packages by title
#'
#' Search portal packages by title. Returns a tibble of matching packages along with package metadata, including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @param title Title to search (case-insensitive).
#' @param limit Maximum number of packages to return. The default is 50. The maximum limit is 1000.
#'
#' @export
#' @examples
#' \dontrun{
#' search_packages("ttc")
#' }
search_packages <- function(title, limit = 50) {
  packages <- ckanr::package_search(
    fq = paste0("title:", '"', title, '"'),
    rows = limit,
    url = opendatatoronto_ckan_url,
    as = "table"
  )

  if (length(packages[["results"]]) == 0) {
    package_res_init
  } else {
    complete_package_res(as.list(packages[["results"]]))
  }
}
