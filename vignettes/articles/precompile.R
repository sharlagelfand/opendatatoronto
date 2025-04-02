# Precompile articles

compile_article <- function(article) {
  rmarkdown::render(
    paste0("vignettes/articles/", article, ".Rmd"),
    output_file =
      paste0(article, ".pdf"),
    output_format = "pdf_document",
    output_dir = "inst/doc"
  )
}

compile_article("multifile_zip_resources")
compile_article("multisheet_resources")
compile_article("opendatatoronto")
compile_article("spatial_data")
