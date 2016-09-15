#' @name CountReg
#' @title Regression Models for Dispersed Count Data
#' @docType package
#' @description The CountReg package contains functions to modelling
#'     count data via likelihood-based approach with a S4
#'     implementation. The models considered are Generalized-Poisson,
#'     COM-Poisson and Gamma-Count and methods for the models also are
#'     provided.
#'
NULL

## @name .onAttach
## @title Message on Attach Package
## @description Function to show welcome message when package is
##     attached.
## @author Eduardo E. Ribeiro Jr <edujrrib@gmail.com> and Walmes
##     M. Zeviani <walmes@ufpr.br>
.onAttach <- function(libname, pkgname) {
    pkg.info <- drop(read.dcf(
        file = system.file("DESCRIPTION", package = "CountReg"),
        fields = c("Package", "Title", "Version", "Date", "URL")
    ))
    dashes <- paste0(rep("----------", times = 7), collapse = "")
    packageStartupMessage(
        paste0(dashes, "\n  ",
               pkg.info["Package"], ": ", pkg.info["Title"], "\n  ",
               "version ", pkg.info["Version"], " (build on ",
               pkg.info["Date"], ") is now loaded.\n\n  ",
               "For support, collaboration or bug report, visit: \n    ",
               pkg.info["URL"], "\n",
               dashes)
    )
}
