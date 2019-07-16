#' List packages.
#'
#' @param limit The maximum number of packages to return (default is 31).
#'
#' @export
#' @examples \dontrun{
#' get_packages(5)
#' }
get_packages <- function(limit = 31) {
  limit <- check_limit(limit)

  packages <- ckanr::package_list_current(limit = limit, url = opendatatoronto_ckan_url, as = "table")

  packages_relevant_cols <- packages[, c("title", "id", "topics", "excerpt", "dataset_category", "formats", "refresh_rate")]

  tibble::as_tibble(packages_relevant_cols)
}
