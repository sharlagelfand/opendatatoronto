#' List resources for a package
#'
#' @param package_id The ID of the package whose resources you are listing.
#'
#' @export
#' @examples
#' \dontrun{
#' list_package_resources("1db34737-ffad-489d-a590-9171d500d453")
#' }
list_package_resources <- function(package_id) {
  package_id <- check_package_id(package_id)

  package_res <- try(
    ckanr::package_show(id = package_id, url = opendatatoronto_ckan_url, as = "table"),
    silent = TRUE
  )

  package_res <- check_package_found(package_res, package_id)

  if (package_res[["num_resources"]] == 0) {
    tibble::tibble(
      name = character(),
      id = character(),
      format = character()
    )
  } else {
    resources <- package_res[["resources"]]
    res <- resources[, c("name", "id", "format")]
    tibble::as_tibble(res)
  }
}

# Helpers

check_package_id <- function(package_id) {
  if (!is.character(package_id)) {
    stop("`package_id` must be a character vector.",
         call. = FALSE
    )
  } else if (length(package_id) != 1) {
    stop("`package_id` must be a length 1 character vector.",
         call. = FALSE
    )
  } else {
    package_id
  }
}

check_package_found <- function(res, package_id) {
  if (class(res) == "try-error" && (grepl("404", res) || grepl("403", res))) {
    stop(paste0('`package` "', package_id, '" was not found.'),
         call. = FALSE
    )
  } else {
    res
  }
}
