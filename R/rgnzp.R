#' @useDynLib gammacount
#' @importFrom Rcpp sourceCpp
NULL

#' @name rgnzp
#' @author Walmes Zeviani, \email{walmes@@ufpr.br}.
#' @export
#' @title Density, distribution function, quantile function and random
#'     generation for the Generalized Poisson
#' @description Formula and etc.
#' @param n Number of observations to be generated.
#' @param lambda Vector that represents the mean (expected value) of the
#'     distribution (\code{lambda > 0}).
#' @param alpha Vector that represents the dispersion parameter of the
#'     distribution. Values of \code{alpha > 0} implies in
#'     overdispersion while \code{alpha < 0} implies in
#'     subdispersion. When \code{alpha = 0}, the Generalized Poisson
#'     reduces to the Poisson distribution.
#' @return \code{rgnzp} returns a vector of random generated numbers.
#' @details The function to generate random numbers is implemented in
#'     C++.
#' @examples
#'
#' rgnzp(n = 10, lambda = 5, alpha = 0)
#'
rgnzp <- function(n, lambda, alpha = 0) {
    stopifnot(all(lambda > 0))
    n <- as.integer(n[1])
    stopifnot(n > 0)
    stopifnot(all((1 - lambda * alpha) > 0))
    ll <- length(lambda)
    la <- length(alpha)
    if (ll == 1 & la == 1) {
        x <- .rgnzp_esc(n, lambda, alpha)
    } else {
        if (ll >= la) {
            r <- ll/la
        } else {
            r <- la/ll
        }
        if (r %% 1 != 0) {
            stop(paste("`lambda` and `alpha` aren't",
                       "length compatiple."))
        }
        L <- data.frame(lambda = lambda, alpha = alpha)
        if (nrow(L) != n) {
            stop(paste("`n` is not multiple of the length of",
                       "`lambda` and/or `alpha` vectors."))
        }
        x <- .rgnzp_vec(n, L$lambda, L$alpha)
    }
    return(x)
}
