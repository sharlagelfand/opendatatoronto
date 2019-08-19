#' Open the resource's package page in your browser
#'
#' Opens a browser to the resource's package page on the City of Toronto Open Data Portal.
#'
#' @param resource A way to identify the resource. Either a resource ID (passed as a character vector directly) or a single resource resulting from \code{\link{list_package_resources}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ttc_subway_delays <- search_packages("ttc subway delay")
#' res <- list_package_resources(ttc_subway_delays)
#' browse_resource(res[1, ])
#' }
browse_resource <- function(resource) {
  resource_id <- as_id(resource)

  resource_res <- try(
    ckanr::resource_show(id = resource_id, url = opendatatoronto_ckan_url, as = "list"),
    silent = TRUE
  )
  resource_res <- check_resource_found(resource_res, resource_id)

  browse_package(resource_res[["package_id"]])
}
