#' List packages
#'
#' List packages available on the portal.
#'
#'
#' @param limit The maximum number of packages to return. The default is 50.
#'
#' @export
#'
#' @return A tibble of available packages and metadata, including \code{title},
#' \code{id}, \code{topics}, \code{civic_issues}, \code{dataset_category},
#' \code{num_resources} (the number of resources in the package), \code{formats}
#' (the different formats of the resources), \code{refresh_rate}
#' (how often the package is refreshed), and \code{last_refreshed}
#' (the date it was last refreshed).
#'
#' @examples
#' \donttest{
#' list_packages(5)
#' }
list_packages <- function(limit = 50) {
  limit <- check_limit(limit)

  packages <- ckanr::package_list_current(
    limit = limit,
    url = opendatatoronto_ckan_url,
    as = "table"
  )

  complete_package_res(as.list(packages))
}
