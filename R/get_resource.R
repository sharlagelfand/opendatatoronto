#' Download a resource into your R session
#'
#' @param resource A way to identify the resource. Either a resource ID (passed as a vector directly) or a single resource resulting from \code{\link{list_package_resources}}
#' @export
#' @examples
#' \dontrun{
#' res <- list_package_resources("1db34737-ffad-489d-a590-9171d500d453")
#' get_resource(resource = res[1, "id"])
#' res[["id"]]
#' get_resource("b9214fd7-60d1-45f3-8463-a6bd9828f8bf")
#' }
get_resource <- function(resource) {
  resource_id <- as_resource_id(resource)

  resource_res <- try(
    ckanr::resource_show(resource_id, url = opendatatoronto_ckan_url, as = "list"),
    silent = TRUE
  )

  resource_res <- check_resource_show_results(resource_res, resource_id)

  format <- check_format(resource_res[["format"]])

  if (resource_res[["datastore_active"]]) {
    res <- get_datastore_resource(resource_id)
    res <- check_geometry_resource(res, resource_id)
  } else {
    res <- ckanr::ckan_fetch(x = resource_res[["url"]], store = "session", format = format)
  }

  if (inherits(res, "sf")) {
    res
  } else if (is.data.frame(res)) {
    tibble::as_tibble(res)
  } else {
    lapply(X = res, FUN = tibble::as_tibble)
  }
}

check_id_in_resource <- function(resource) {
  if (!("id" %in% names(resource))) {
    stop('`resource` must contain a column "id".',
         call. = FALSE
    )
  } else {
    resource
  }
}

as_resource_id <- function(resource) {
  if (is.data.frame(resource)) {
    if (nrow(resource) == 1) {
      resource <- check_id_in_resource(resource)
      resource_id <- resource[["id"]]
    } else {
      stop("`resource` must be a 1 row data frame or a length 1 character vector.",
           call. = FALSE
      )
    }
  } else if (!(is.vector(resource) && length(resource) == 1 && is.character(resource))) {
    stop("`resource` must be a 1 row data frame or a length 1 character vector.",
         call. = FALSE
    )
  } else {
    resource
  }
}

check_resource_show_results <- function(res, resource_id) {
  if (class(res) == "try-error" &&
    (grepl("404", res) || grepl("403", res))) {
    stop(paste0('resource "', resource_id, '" was not found.'),
      call. = FALSE
    )
  }
  else {
    res
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

check_geometry_resource <- function(res, resource_id) {
  if ("LATITUDE" %in% toupper(colnames(res)) && "LONGITUDE" %in% toupper(colnames(res))) {
    res <- tibble::as_tibble(res)
    res <- check_for_sf(res, resource_id)
  } else {
    res
  }
}

check_for_sf <- function(res, resource_id) {
  if (!requireNamespace("sf", quietly = TRUE)) {
    warning(paste0('The `sf` package is required to get resource "', resource_id, '" as an `sf` object. Without it, the resource is returned as a tibble.'), call. = FALSE)
    res
  } else {
    sf::st_as_sf(res, coords = c("LONGITUDE", "LATITUDE"), remove = FALSE, crs = 4326)
  }
}
