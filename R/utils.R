opendatatoronto_ckan_url <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/"

as_id <- function(x) {
  object_name <- deparse(substitute(x))

  if (is.data.frame(x)) {
    if (nrow(x) == 1) {
      x <- check_id_in_resource(x)
      as.character(x[["id"]])
    } else {
      stop(paste0("`", object_name, "` must be a 1 row data frame or a length 1 character vector."),
        call. = FALSE
      )
    }
  } else if (!(is.vector(x) && length(x) == 1 && is.character(x))) {
    stop(paste0("`", object_name, "` must be a 1 row data frame or a length 1 character vector."),
      call. = FALSE
    )
  } else if (grepl("open.toronto.ca/dataset/", x)) {
    package_id_from_url(x)
  } else {
    x
  }
}
