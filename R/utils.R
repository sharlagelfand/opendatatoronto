opendatatoronto_ckan_url <- "https://ckan0.cf.opendata.inter.sandbox-toronto.ca/"

check_limit <- function(limit) {
  if (length(limit) != 1) {
    stop("`limit` must be a length 1 positive integer vector.",
         call. = FALSE
    )
  }
  else if (!is.numeric(limit) ||
           !(limit %% 1 == 0) ||
           limit <= 0 ||
           limit == Inf) {
    stop("`limit` must be a positive integer.",
         call. = FALSE
    )
  }
  else {
    limit
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
