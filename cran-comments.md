## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

local macOS install, R 4.1.0
macOS (on GitHub Actions), R 4.1.3
windows (on GitHub Actions), R 4.1.3
ubuntu 20.04 (on GitHub Actions), devel
ubuntu 20.04 (on GitHub Actions), R 4.1.3
ubuntu 20.04 (on GitHub Actions), R 4.0.5
win-builder (devel and release)

R CMD check results

0 errors | 0 warnings | 0 notes

This version fixes an example in `get_resource()` that previously errored due to `list_package_resources()` returning more than one resource - `get_resource()` only allows retrieving one resource at a time, and errors informatively (prior to hitting the API) when there is more than one requested. I have remedied this by explicitly setting `head(1)` in the example. In interactive use, the error helps users to understand that only one resource may be requested, and to request iteratively if they need more than one.

Thanks very much, Sharla Gelfand
