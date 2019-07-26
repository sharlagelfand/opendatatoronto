#' Download a resource into your R session
#'
#' @param url URL of the resource
#' @param format Format of the resource
#'
#' @export
#' @examples
#' \dontrun{
#' res <- list_package_resources("832a5967-15a8-4dce-aad5-36d2d45f9d04")
#' get_resource(url = res[1, "url"], format = res[1, "format"])
#' }
get_resource <- function(url, format) {
  format <- check_format(format)

  res <- ckanr::ckan_fetch(x = url, store = "session", format = format)

  tibble::as_tibble(res)

  # if(is.data.frame(res)){
  #   tibble::as_tibble(res)
  # }
  # else {
  #   lapply(X = res, FUN = tibble::as_tibble)
  #   }
}
