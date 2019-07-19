#' Download a resource into your R session
#'
#' @param url URL of the resource
#' @param format Format of the resource
#' @param store One of session (default) or disk. session stores in R session, and disk saves the file to disk.
#' @param path If store = disk, you must give a path to store the file to
#'
#' @export
#' @examples \dontrun{
#' res <- list_package_resources("832a5967-15a8-4dce-aad5-36d2d45f9d04")
#' list_resource(url = res[1, "url"], format = res[1, "format"])
#' }
get_resource <- function(url, format, store = "session", path = "file") {
  format <- check_format(format)

  if (format == "GEOJSON") {
    query <- list(format = "geojson", projection = "4326")
  }
  else {
    query <- NULL
  }

  res <- ckanr::ckan_fetch(x = url, store = store, path = path, format = format, args = query)

  if (format == "GEOJSON") {
    res$features <- tibble::as_tibble(res$features)
    res
  }
  else {
    tibble::as_tibble(res)
  }
}
