#' Show a package's metadata.
#'
#' Show a package's metadata, including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly) or the package's URL from the portal
#'
#' @export
#' @examples
#' \dontrun{
#' show_package("c01c6d71-de1f-493d-91ba-364ce64884ac")
#' }
show_package <- function(package) {
  package_id <- as_id(package)

  package_res <- try(
    ckanr::as.ckan_package(package_id, url = opendatatoronto_ckan_url),
    silent = TRUE
  )

  package_res <- check_found(package_res, package, "package")

  complete_package_res(package_res)
}
