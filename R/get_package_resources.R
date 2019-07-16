#' Get Resources for a Package
#'
#' @param package_id Package ID
#' @export
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

check_package_id <- function(package_id) {
  if (!is.character(package_id)) {
    stop("`package_id` must be a character vector.",
      call. = FALSE
    )
  }
  else if (length(package_id) != 1) {
    stop("`package_id` must be a length 1 character vector.",
      call. = FALSE
    )
  }
  else {
    package_id
  }
}

check_package_show_results <- function(res) {
  if (class(res) == "try-error" && grepl("404", res)) {
    stop("`package_id` was not found.",
      call. = FALSE
    )
  }
  else {
    res
  }
}
