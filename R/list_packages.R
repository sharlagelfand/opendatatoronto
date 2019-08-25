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

  packages_relevant_cols <- packages[, c("title", "id", "topics", "excerpt", "dataset_category", "num_resources", "formats", "refresh_rate", "last_refreshed")]

  packages_relevant_cols[["last_refreshed"]] <- as.Date(packages_relevant_cols[["last_refreshed"]])

  tibble::as_tibble(packages_relevant_cols)
}
