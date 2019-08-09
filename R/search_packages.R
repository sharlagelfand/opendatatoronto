#' Search packages by title
#'
#' @param title Title to search (case-insensitive).
#' @param limit Maximum number of packages to return. The default (and the maximum possible value) is 1000.
#'
#' @export
#' @examples
#' \dontrun{
#' search_packages("ttc")
#' }
search_packages <- function(title, limit = 1000) {
  resp <- httr::GET(file.path(sub("/$", "", opendatatoronto_ckan_url), "api/3/action/package_search"), query = list(fq = paste0("title:", '"', title, '"'), rows = limit))

  content <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = TRUE)

  if (content[["result"]][["count"]] == 0) {
    tibble::tibble(
      title = character(),
      id = character(),
      topics = character(),
      excerpt = character(),
      dataset_category = character(),
      formats = character(),
      refresh_rate = character(),
      num_resource = character()
    )
  } else {
    res <- tibble::as_tibble(content[["result"]][["results"]])
    res[, c("title", "id", "topics", "excerpt", "dataset_category", "formats", "refresh_rate", "num_resources")]
  }
}
