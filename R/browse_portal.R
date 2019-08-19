#' Open the City of Toronto Open Data Portal in your browser
#'
#' Opens a browser to \code{https://open.toronto.ca}.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' browse_portal()
#' }
browse_portal <- function() {
  if (interactive()) {
    utils::browseURL(url = "https://open.toronto.ca/", browser = getOption("browser"))
  }

  invisible("https://open.toronto.ca/")
}
