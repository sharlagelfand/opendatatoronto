#' Open the City of Toronto Open Data Portal in your browser
#'
#' Opens a browser to \code{https://open.toronto.ca}.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' open_portal()
#' }
open_portal <- function(browser = getOption("browser")) {
  if(interactive()){
    utils::browseURL(url = "https://open.toronto.ca/", browser = browser)
  }

  invisible("https://open.toronto.ca/")
}
