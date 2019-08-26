#' Search packages by title
#'
#' @param title Title to search (case-insensitive).
#' @param limit Maximum number of packages to return. The default (and the maximum possible value) is 1000.
#'
#' @export
#' @examples
#' \dontrun{
#' search_packages("ttc")
#' }
search_packages <- function(title, limit = 1000) {
  packages <- ckanr::package_search(fq = paste0("title:", '"', title, '"'), rows = limit, url = opendatatoronto_ckan_url, as = "table")

  if (length(packages[["results"]]) == 0) {
    package_res_init
  } else {
    complete_package_res(as.list(packages[["results"]]))
  }
}
