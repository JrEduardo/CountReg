#' @useDynLib gammacount, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL

#' @name dpqr-gcnt
#' @author Walmes Zeviani, \email{walmes@@ufpr.br}.
#' @title Functions for the Gamma Count Distribution
#' @description Probability function, distribution function, quantile
#'     function and random generation for the Gamma Count distribution.
#' @param x Positive interger value.
#' @param p A vector of probabilities.
#' @param n An integer vector of length one that is the amount of random
#'     numbers to be generated.
#' @param lambda A numeric vector with values for the location parameter
#'     of the Gamma Count distribution.
#' @param alpha A numeric vector with values for the dispersion
#'     parameter of the Gamma Count distribution.
#' @param offset A numeric vector with the correponding space size where
#'     the counts are observed.
#' @param log A logical value. If \code{TRUE}, probabilities \code{p}
#'     are given as \code{log(p)}.
#' @param lower.tail A logical value. If \code{TRUE} (default),
#'     probabilities are \eqn{\Pr(X \leq x)} otherwise, \eqn{\Pr(X > x)}.
#' @return \code{dgcnt} gives the probability \eqn{\Pr(X = x)},
#'     \code{pgcnt} gives the cummulated probability \eqn{\Pr(X \leq x)}
#'     or its complement, \code{qgcnt} gives the quantiles and
#'     \code{rgcnt} generates random values.
#'
NULL

#' @rdname dpqr-gcnt
#' @export
#' @importFrom stats pgamma
#' @details The function \code{dgcnt()} is implemented in R. The
#'     probability function of the Gamma Count is based on the
#'     difference of cumulated probabilities of the Gamma density
#'     function. These differences are numerically non distinguishable
#'     of zero at the tails, so the logarithm of the probabilities is
#'     \code{-Inf}. We decide replace \code{-Inf} by \code{-744}, that
#'     is the logarithm of the smallest value.
#' @examples
#'
#' dgcnt(5, 5, 1)
#' dpois(5, 5, 1)
#'
dgcnt <- function(x,
                  lambda,
                  alpha,
                  log = FALSE,
                  offset = 1) {
    p <- pgamma(q = offset,
                shape = x * alpha,
                rate = alpha * lambda) -
        pgamma(q = offset,
               shape = (x + 1) * alpha,
               rate = alpha * lambda)
    if (log) {
        p <- log(p)
        i <- !is.finite(p)
        # log(.Machine$double.xmin * (1.15e-16))
        p[i] <- -744.440072;
        # p[i] <- dnorm(x[i],
        #               mean = offset * lambda,
        #               sd = sqrt(offset * lambda)/alpha,
        #               log = TRUE)
    }
    return(p)
}

#' @rdname dpqr-gcnt
#' @export
#' @details BBBB
pgcnt <- function(x, lambda, alpha = 1, lower.tail = TRUE, log = FALSE) {
    message("Not yet implemented.")
}

#' @rdname dpqr-gcnt
#' @export
#' @details The \code{qgcnt()} is implemented in \strong{C++} in two
#'     versions. The first is implemented for the \emph{idd} case that
#'     is when both \code{lambda} and \code{alpha} are vectors of length
#'     one. In this case, the vector of probabilities \code{p} is
#'     ordered for the quantile search in the ascending direction. At
#'     the end, the values are restored to the original order. The other
#'     version deals with the \emph{non idd} case by recursive calls of
#'     the function at each vector point. For simulation studies is
#'     desirable use the \emph{idd} version because it is faster.
#' @examples
#'
#' qgcnt(runif(5), 10, 1)
#' qpois(runif(5), 10)
#'
qgcnt <- function(p, lambda, alpha = 1) {
    stopifnot(all(lambda > 0))
    stopifnot(all(alpha > 0))
    stopifnot(all(p >= 0 &  p < 1))
    if (length(lambda) == 1L & length(alpha) == 1L & length(p) > 1L) {
        o <- order(p)
        q <- .qgcnt_iid(p[o], lambda, alpha)
        return(q[o])
    } else {
        q <- mapply(p, lambda, alpha, FUN = .qgcnt_one)
        return(q)
    }
}

#' @rdname dpqr-gcnt
#' @export
#' @details The \code{rgcnt()} is implemented in \strong{C++} in two
#'     versions. The first is implemented for the \emph{idd} case that
#'     is when both \code{lambda} and \code{alpha} are vectors of length
#'     one. In this case, a vector of \code{n} uniform random numbers is
#'     ordered for the quantile search in the ascending direction. At
#'     the end, the values are randomized in the vector. The other
#'     version deals with the \emph{non idd} case by recursive calls of
#'     the function at each vector point. For simulation studies is
#'     desirable use the \emph{idd} version because it is faster.
#' @examples
#'
#' x <- rgcnt(1000, 10, 1)
#'
#' plot(ecdf(x))
#' curve(ppois(x, 10), add = TRUE, type = "s", col = 2)
#'
rgcnt <- function(n, lambda, alpha = 1) {
    stopifnot(all(lambda > 0))
    stopifnot(all(alpha > 0))
    if (length(lambda) == 1L & length(alpha) == 1L & n > 1L) {
        .rgcnt_iid(n, lambda, alpha)
    } else {
        mapply(lambda = lambda, alpha = alpha, FUN = .rgcnt_one)
    }
}
