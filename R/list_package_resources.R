#' List resources for a package
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly), a single package resulting from \code{\link{list_packages}} or \code{\link{search_packages}}, or the package's URL from the portal
#'
#' @export
#' @examples
#' \dontrun{
#' list_package_resources("1db34737-ffad-489d-a590-9171d500d453")
#' 
#' list_package_resources("https://open.toronto.ca/dataset/ttc-subway-delay-data")
#' }
list_package_resources <- function(package) {
  package_id <- as_id(package)

  package_res <- try(
    ckanr::package_show(id = package_id, url = opendatatoronto_ckan_url, as = "table"),
    silent = TRUE
  )

  package_res <- check_found(package_res, package_id, "package")

  if (package_res[["num_resources"]] == 0) {
    tibble::tibble(
      name = character(),
      format = character(),
      id = character()
    )
  } else {
    resources <- package_res[["resources"]]
    res <- resources[, c("name", "format", "id", "last_modified")]
    tibble::as_tibble(res)
  }
}
