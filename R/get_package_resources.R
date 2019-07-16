#' Get Resources for a Package
#'
#' @param package_id Package ID
#' @export
get_package_resources <- function(package_id) {
  package_res <- ckanr::package_show(id = package_id, url = "https://ckan0.cf.opendata.inter.sandbox-toronto.ca/", as = "table")

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
