opendatatoronto_ckan_url <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/"

as_id <- function(x) {
  object_name <- deparse(substitute(x))

  if (is.data.frame(x)) {
    if (nrow(x) == 1) {
      x <- check_id_in_df(x, object_name)
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

check_id_in_df <- function(x, name) {
  if (!("id" %in% names(x))) {
    stop(paste0("`", name, '` must contain a column "id".'),
      call. = FALSE
    )
  } else {
    x
  }
}

check_found <- function(res, id, name) {
  if (inherits(res, "try-error") && (grepl("404", res) || grepl("403", res))) {
    stop(paste0("`", name, '` "', id, '" was not found.'),
      call. = FALSE
    )
  } else {
    res
  }
}

package_id_from_url <- function(package_url) {
  if (!grepl("^open.toronto.ca/dataset/|^https://open.toronto.ca/dataset|^http://open.toronto.ca/dataset", package_url)) {
    stop("Package URL must start with open.toronto.ca/dataset/",
      call. = FALSE
    )
  }

  package_title <- basename(package_url)
  search_package_title <- search_packages(package_title)

  if (nrow(search_package_title) == 0) {
    stop(paste0("No package id found matching the URL '", package_url, "'."),
      call. = FALSE
    )
  }

  search_package_title[["title"]] <- parse_package_title(search_package_title[["title"]])
  matching_package <- search_package_title[which(search_package_title[["title"]] == package_title), ]

  if (nrow(matching_package) == 0) {
    stop(paste0("No package id found matching the URL '", package_url, "'."),
      call. = FALSE
    )
  } else if (nrow(matching_package) > 1) {
    warning("More than one package id found matching the URL.",
      call. = FALSE
    )
    matching_package[["id"]]
  } else if (nrow(matching_package) == 1) {
    matching_package[["id"]]
  }
}

parse_package_title <- function(x) {
  lower <- tolower(x)
  dash <- gsub(pattern = "[^[:alnum:]]", replacement = "-", x = lower) # replace all non-alphanumeric with -'s
  remove_repeated <- gsub(pattern = "(-)\\1+", replacement = "-", x = dash) # only one - in a row
  gsub(pattern = "-$", replacement = "", x = remove_repeated) # ends with -
}

check_limit <- function(limit) {
  if (length(limit) != 1) {
    stop("`limit` must be a length 1 positive integer vector.",
      call. = FALSE
    )
  } else if (!is.numeric(limit) ||
    !(limit %% 1 == 0) ||
    limit <= 0 ||
    limit == Inf) {
    stop("`limit` must be a positive integer.",
      call. = FALSE
    )
  } else {
    limit
  }
}

check_internet <- function() {
  if (!curl::has_internet()) {
    stop("`opendatatoronto` does not work offline. Please check your internet connection.",
      call. = FALSE
    )
  }
}
