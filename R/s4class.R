# library(bbmle)
# getSlots("mle2")

#' @title An S4 class for the Gamma-Count regression model
#' @description Creates a class for the Gamma-Count model by
#'     inheritance from \code{mle2} class.
#' @import bbmle
setClass(Class = "gcnt", contains = "mle2")
# getSlots("gcnt")
