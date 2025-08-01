cat("Checking installation of R development packages... ")
pkgs <- c()
if (!requireNamespace("languageserver", quietly = TRUE)) {
    pkgs <- c(pkgs, "languageserver")
}
if (!requireNamespace("httpgd", quietly = TRUE)) {
    pkgs <- c(pkgs, "nx10/httpgd")
}
if (!requireNamespace("vscDebugger", quietly = TRUE)) {
    pkgs <- c(pkgs, "ManuelHentschel/vscDebugger")
}
if (length(pkgs) > 0) {
    cat("\nInstalling missing R development packages...\n")
    renv::install(pkgs)
} else {
    cat("done!\n")
}
