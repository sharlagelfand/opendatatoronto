#' List packages
#'
#' @param limit The maximum number of packages to return. The default is 50.
#'
#' @export
#' @examples
#' \dontrun{
#' list_packages(5)
#' }
list_packages <- function(limit = 50) {
  limit <- check_limit(limit)

  packages <- ckanr::package_list_current(limit = limit, url = opendatatoronto_ckan_url, as = "table")

  complete_package_res(as.list(packages))
}
