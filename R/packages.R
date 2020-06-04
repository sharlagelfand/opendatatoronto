#' List packages
#'
#' List packages available on the portal.
#'
#'
#' @param limit The maximum number of packages to return. The default is 50.
#'
#' @export
#'
#' @return A tibble of available packages and metadata, including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{excerpt}, \code{publisher}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @examples
#' \donttest{
#' list_packages(5)
#' }
list_packages <- function(limit = 50) {
  check_internet()
  limit <- check_limit(limit)

  packages <- ckanr::package_list_current(
    limit = limit,
    url = opendatatoronto_ckan_url,
    as = "table"
  )

  complete_package_res(as.list(packages))
}

#' Search packages by title
#'
#' Search portal packages by title.
#'
#' @param title Title to search (case-insensitive).
#' @param limit Maximum number of packages to return. The default is 50. The maximum limit is 1000.
#'
#' @export
#'
#' @return A tibble of matching packages along with package metadata, including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{excerpt}, \code{publisher}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @examples
#' \donttest{
#' search_packages("ttc")
#' }
search_packages <- function(title, limit = 50) {
  check_internet()
  packages <- ckanr::package_search(
    fq = paste0("title:", '"', title, '"'),
    rows = limit,
    url = opendatatoronto_ckan_url,
    as = "table"
  )

  if (length(packages[["results"]]) == 0) {
    names(package_res_init)[which(names(package_res_init) == "owner_division")] <- "publisher"
    package_res_init
  } else {
    complete_package_res(as.list(packages[["results"]]))
  }
}

#' Show a package's metadata
#'
#' Show a portal package's metadata.
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly) or the package's URL from the portal.
#'
#' @export
#'
#' @return A tibble including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{excerpt}, \code{publisher}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @examples
#' \donttest{
#' show_package("c01c6d71-de1f-493d-91ba-364ce64884ac")
#' }
show_package <- function(package) {
  check_internet()
  package_id <- as_id(package)

  package_res <- try(
    ckanr::as.ckan_package(package_id, url = opendatatoronto_ckan_url),
    silent = TRUE
  )

  package_res <- check_found(package_res, package, "package")

  complete_package_res(package_res)
}

package_res_init <- tibble::tibble(
  title = character(),
  id = character(),
  topics = character(),
  civic_issues = character(),
  owner_division = character(),
  excerpt = character(),
  dataset_category = character(),
  num_resources = integer(),
  formats = character(),
  refresh_rate = character(),
  last_refreshed = as.Date(character())
)

package_cols <- names(package_res_init)

complete_package_res <- function(res) {
  res <- res[names(res) %in% package_cols]
  for (i in package_cols) {
    if (is.null(res[[i]])) {
      res[[i]] <- NA
    }
    col_class <- class(package_res_init[[i]])
    if (col_class == "Date") {
      res[[i]] <- as.Date(res[[i]])
    } else {
      class(res[[i]]) <- col_class
    }
  }
  res_cols <- tibble::as_tibble(res[package_cols])

  names(res_cols)[which(names(res_cols) == "owner_division")] <- "publisher"

  res_cols
}
