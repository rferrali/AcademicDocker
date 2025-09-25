#!/usr/bin/env Rscript

#' Check and Install R Development Dependencies
#' 
#' This script checks for missing R package dependencies and installs them using renv.
#' It handles both regular package dependencies (from DESCRIPTION file) and optional
#' VS Code-specific development packages.
#' 
#' @description
#' The script performs the following operations:
#' 1. Reads package dependencies from DESCRIPTION file (if present)
#' 2. Optionally includes VS Code development packages (unless --no-vscode is specified)
#' 3. Checks which packages are missing from the current R library
#' 4. Installs missing packages using renv::install()
#' 
#' @param --no-vscode Optional command line argument to skip VS Code packages
#' 
#' @details
#' VS Code packages included by default:
#' - languageserver: R language server for VS Code
#' - nx10/httpgd: HTTP graphics device for VS Code
#' - ManuelHentschel/vscDebugger: R debugger for VS Code
#' 
#' @examples
#' # Check and install all dependencies (including VS Code packages)
#' Rscript check_dependencies.R
#' 
#' # Check and install only DESCRIPTION dependencies (skip VS Code packages)
#' Rscript check_dependencies.R --no-vscode
#' 
#' @author Data Project
#' @date September 2025

cat("Checking installation of R development packages... ")
library(desc)

# Parse command line arguments
vscode <- FALSE
args <- commandArgs(trailingOnly = TRUE)
vscode <- ! "--no-vscode" %in% args

# VS Code development packages
vscode_deps <- c(
  "languageserver",      # R language server for VS Code
  "nx10/httpgd",        # HTTP graphics device for VS Code  
  "ManuelHentschel/vscDebugger"  # R debugger for VS Code
)

# Read DESCRIPTION file if it exists
desc <- tryCatch({
    description$new()
  }, error = function(e) NULL)

# Extract dependencies from DESCRIPTION file
deps <- if(!is.null(desc)) {
  c(
    desc$get_deps()$package,  # Regular dependencies
    desc$get_remotes()        # Remote dependencies (e.g., GitHub)
  )
} else {
  character(0)
}

# Add VS Code dependencies if not excluded
if(vscode) {
  deps <- c(deps, vscode_deps)
}

# Create data frame with package info
deps <- data.frame(
  package = deps,
  package_name = gsub(".*/", "", deps)  # Extract package name from GitHub repos
)

# Check which packages are missing
deps$missing <- !sapply(deps$package_name, function(pkg) {
  requireNamespace(pkg, quietly = TRUE)
})

deps <- deps[deps$missing, ]

# Install missing packages or report success
if(nrow(deps) == 0) {
  cat("Done.\n")
} else {
  cat(paste0("\nInstalling ", nrow(deps), " missing packages...\n"))
  renv::install(deps$package)
}
