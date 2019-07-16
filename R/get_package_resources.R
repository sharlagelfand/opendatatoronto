#' Get resource for a package
#'
#' @param package_id The ID of the package whose resources you are getting.
#'
#' @export
#' @example \dontrun{
#' get_package_resources("0241552c-a22e-470e-ad5b-aa7f35ec2fa3")
#' }
get_package_resources <- function(package_id) {
  package_id <- check_package_id(package_id)

  package_res <- try(
    ckanr::package_show(id = package_id, url = opendatatoronto_ckan_url, as = "table"),
    silent = TRUE
  )

  package_res <- check_package_show_results(package_res)

  if (package_res[["num_resources"]] == 0) {
    tibble::tibble(
      name = character(),
      id = character(),
      format = character(),
      created = character(),
      url = character(),
      datastore_active = character()
    )
  }
  else {
    resources <- package_res[["resources"]]
    res <- resources[, c("name", "id", "format", "created", "url", "datastore_active")]

    res[["url"]] <- ifelse(res[["datastore_active"]], paste0("https://ckan0.cf.opendata.inter.sandbox-toronto.ca/download_resource/", res[["id"]]), res[["url"]])

    tibble::as_tibble(res[, c("name", "id", "format", "created", "url")])
  }
}
