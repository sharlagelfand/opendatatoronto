#' List resources for a package
#'
#' List resources for a package on the portal. Returns a tibble of resources along with metadata, including \code{name}, \code{id}, \code{format} (the format of the resource file), and \code{last_modified} (the date the resource was last modified).
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly), a single package resulting from \code{\link{list_packages}} or \code{\link{search_packages}}, or the package's URL from the portal.
#'
#' @export
#' @examples
#' \dontrun{
#' list_package_resources("1db34737-ffad-489d-a590-9171d500d453")
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
      id = character(),
      format = character()
    )
  } else {
    resources <- package_res[["resources"]]
    res <- resources[, c("name", "id", "format", "last_modified")]
    res[["last_modified"]] <- as.Date(res[["last_modified"]])
    tibble::as_tibble(res)
  }
}
