cat("Checking installation of R unit-testing packages... ")
pkgs <- c()
if (!requireNamespace("testthat", quietly = TRUE)) {
    pkgs <- c(pkgs, "testthat")
}
if (length(pkgs) > 0) {
    cat("\nInstalling missing R unit-testing packages...\n")
    renv::install(pkgs)
} else {
    cat("done!\n")
}
