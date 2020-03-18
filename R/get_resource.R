#' Download a resource into your R session
#'
#' Download a resource from the portal directly into your R session. CSV, XLS, XLSX, XML, JSON, SHP, ZIP, and GeoJSON resources are supported.
#'
#' @param resource A way to identify the resource. Either a resource ID (passed as a character vector directly) or a single resource resulting from \code{\link{list_package_resources}}.
#'
#' @export
#'
#' @return In most cases, the resource is returned as a tibble or list of tibbles.
#' If it is a spatial resource (i.e. SHP or GeoJSON), it is returned as an sf object.
#'
#' @examples
#' \donttest{
#' res <- list_package_resources("1db34737-ffad-489d-a590-9171d500d453")
#' get_resource(resource = res[1, "id"])
#' res[["id"]]
#' get_resource("b9214fd7-60d1-45f3-8463-a6bd9828f8bf")
#' }
get_resource <- function(resource) {
  resource_id <- as_id(resource)

  resource_res <- try(
    ckanr::resource_show(resource_id,
      url = opendatatoronto_ckan_url,
      as = "list"
    ),
    silent = TRUE
  )

  resource_res <- check_found(resource_res, resource_id, "resource")

  format <- check_format(resource_res[["format"]])

  if (resource_res[["datastore_active"]]) {
    res <- get_datastore_resource(resource_id)
    res <- check_geometry_resource(res, format)
  } else {
    res <- ckanr::ckan_fetch(
      x = resource_res[["url"]],
      store = "session",
      format = format
    )
  }

  if (inherits(res, "sf")) {
    res_crs <- sf::st_crs(res)
    res <- tibble::as_tibble(res)
    sf::st_as_sf(res)
  } else if (is.data.frame(res)) {
    tibble::as_tibble(res, .name_repair = "minimal")
  } else {
    res <- nested_lapply_tibble(res)
    names(res) <- names(res)
    res
  }
}

check_format <- function(format) {
  format <- toupper(format)
  if (!(format %in% c("CSV", "XLS", "XLSX", "XML", "JSON", "SHP", "ZIP", "GEOJSON"))) {
    stop(paste(format, "`format` can't be downloaded via package; please visit Open Data Portal directly to download. \n Supported `format`s are: CSV, XLS, XLSX, XML, JSON, SHP, ZIP, GEOJSON."),
      call. = FALSE
    )
  }
  else {
    format
  }
}

get_datastore_resource <- function(resource_id) {
  initial_res <- ckanr::ds_search(
    resource_id = resource_id,
    url = opendatatoronto_ckan_url,
    limit = 0,
    as = "table"
  )

  n_records <- initial_res[["total"]]

  res <- ckanr::ds_search(
    resource_id = resource_id,
    url = opendatatoronto_ckan_url,
    limit = n_records,
    as = "table"
  )

  res[["records"]]
}

check_geometry_resource <- function(res, format) {
  if (tolower(format) == "geojson") {
    res <- covert_geometry_resource(res)
  } else {
    res
  }
}

covert_geometry_resource <- function(res) {
  res[["geometry"]] <- sf::st_as_sfc(res[["geometry"]], GeoJSON = TRUE, crs = 4326)
  sf::st_as_sf(tibble::as_tibble(res), sf_column_name = "geometry", crs = 4326)
}

tibble_list_elements <- function(x) {
  if (is.list(x) && !inherits(x, "data.frame")) {
    lapply(x, FUN = tibble::as_tibble)
  } else {
    tibble::as_tibble(x)
  }
}

nested_lapply_tibble <- function(x) {
  lapply(x, FUN = tibble_list_elements)
}
