#' Show information on a package
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
