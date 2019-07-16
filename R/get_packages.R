#' List packages.
#'
#' @param limit (numeric) The maximum number of packages to return (optional, default: 31)
#'
#' @export
get_packages <- function(limit = 31) {
  packages <- ckanr::package_list_current(limit = limit, url = opendatatoronto_ckan_url, as = "table")

  packages_relevant_cols <- packages[, c("title", "id", "topics", "excerpt", "dataset_category", "formats", "refresh_rate")]

  tibble::as_tibble(packages_relevant_cols)
}
