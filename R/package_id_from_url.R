#' Get package ID from package portal URL
#'
#' Get the \code{package_id} associated with a given package's URL on the City of Toronto Open Data Portal.
#'
#' @param package_url Package URL from the City of Toronto Open Data Portal
#'
#' @export
#'
#' @examples
#' \dontrun{
#' package_id_from_url("https://open.toronto.ca/dataset/ttc-subway-delay-data")
#' }
package_id_from_url <- function(package_url) {
  if(!grepl("https://open.toronto.ca/dataset/", package_url)) {
    stop("Package URL must contain open.toronto.ca/dataset/",
         call. = FALSE)
  }

  package_title <- basename(package_url)
  search_package_title <- search_packages(package_title)

  if(nrow(search_package_title) == 0){
    stop(paste0("No package id found matching the URL '", package_url, "'."),
         call. = FALSE)
  }

  search_package_title[["title"]] <- parse_package_title(search_package_title[["title"]])
  matching_package <- search_package_title[which(search_package_title[["title"]] == package_title), ]

  if(nrow(matching_package) == 0) {
    stop(paste0("No package id found matching the URL '", package_url, "'."),
         call. = FALSE)
  } else if (nrow(matching_package) > 1) {
    warning("More than one package id found matching the URL.",
            call. = FALSE)
    matching_package[["id"]]
  } else if (nrow(matching_package) == 1){
    matching_package[["id"]]
  }
}
