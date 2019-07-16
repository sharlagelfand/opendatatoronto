#' Download a resource
#'
#' @param url URL for the resource
#' @param format Format of the resource
#' @param store One of session (default) or disk. session stores in R session, and disk saves the file to disk.
#' @param path If store = disk, you must give a path to store the file to
#'
#' @export
download_resource <- function(url, format, store = "session", path = "file") {
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

check_format <- function(format) {
  format <- toupper(format)
  if (!(format %in% c("CSV", "XLS", "XLSX", "XML", "JSON", "SHP", "ZIP", "GEOJSON"))) {
    stop(paste(format, "`format` can't be downloaded via package; please visit Open Data Portal directly to download. \n Supported `format`s are: CSV, XLS, XLSX, XML, JSON, SHP, ZIP, GEOJSON"),
      call. = FALSE
    )
  }
  else {
    format
  }
}
