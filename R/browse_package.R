#' Open the package's page in your browser
#'
#' Opens a browser to the package's page on the City of Toronto Open Data Portal.
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly) or a single package resulting from \code{\link{list_packages}} or \code{\link{search_packages}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ttc_subway_delays <- search_packages("ttc subway delay")
#' browse_package(ttc_subway_delays)
#' }
browse_package <- function(package) {
  package_id <- as_id(package)

  package_res <- try(
    ckanr::package_show(id = package_id, url = opendatatoronto_ckan_url, as = "list"),
    silent = TRUE
  )
  package_res <- check_package_found(package_res, package_id)

  package_title <- package_res[["title"]]

  package_title_url <- parse_package_title(package_title)
  url <- paste0("https://open.toronto.ca/dataset/", package_title_url)
  if (interactive()) {
    utils::browseURL(url = url, browser = getOption("browser"))
  }

  invisible(url)
}

parse_package_title <- function(x) {
  lower <- tolower(x)
  dash <- gsub(lower, pattern = "[^a-zA-Z\\d]", replacement = "-", x = lower) # replace all non-alphanumeric with -'s
  remove_repeated <- gsub(pattern = "(-)\\1+", replacement = "-", x = dash) # only one - in a row
  gsub(pattern = "-$", replacement = "", x = remove_repeated) # ends with -
}
