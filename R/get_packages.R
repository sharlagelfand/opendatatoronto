#' List packages.
#'
#' @param limit (numeric) The maximum number of packages to return (optional, default: 31)
#'
#' @export
get_packages <- function(limit = 31) {
  limit <- check_limit(limit)

  packages <- ckanr::package_list_current(limit = limit, url = opendatatoronto_ckan_url, as = "table")

  packages_relevant_cols <- packages[, c("title", "id", "topics", "excerpt", "dataset_category", "formats", "refresh_rate")]

  tibble::as_tibble(packages_relevant_cols)
}

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
