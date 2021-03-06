#' @name cotton_defol
#' @title Number of Bolls in Cotton under Artifitial Defoliation
#' @description These data are the results of a greenshouse factorial
#'     experiment performed to evaluate the effect of defoliation on the
#'     production of cotton at different growth stages. The experiment
#'     is a \eqn{5\times 5} factorial with 5 replications in a complete
#'     randomized design. The experimental unit was a pot with 2 cotton
#'     plants. The response variable is the number of bolls produced at
#'     the end of the crop cycle. The observed number of cotton bolls is
#'     a count variable with underdispersion (sample variance less than
#'     the sample mean).
#' @format A \code{data.frame} with 125 records and 4 variables,
#'     described below.
#'
#' \itemize{
#'
#' \item \code{defol} A numeric factor with 5 levels that represents the
#'     (artifitial) levels of defoliation (percent in leaf area removed
#'     with scissors) applied for all leaves of the plants.
#'
#' \item \code{phenol} A categorical ordered factor with 5 levels that
#'     represents the (phenological) growth stages of the cotton plants
#'     in which the levels of defoliation was applied.
#'
#' \item \code{rept} Integer variable that indexes each experimenal unit
#'     in each treatment cell.
#'
#' \item \code{bolls} The number of bolls produced (count variable)
#'     evaluated at harvest of cotton.
#'
#' }
#' @references Silva, A. M., Degrande, P. E., Suekane, R., Fernandes,
#'     M. G., Zeviani, W. M. (2012). Impacto de diferentes níveis de
#'     desfolha artificial nos estádios fenológicos do
#'     algodoeiro. \strong{Revista de Ciências Agrárias}, 35(1),
#'     163–172.
#'     \url{http://www.scielo.mec.pt/pdf/rca/v35n1/v35n1a16.pdf}.
#'
#'     Zeviani, W. M., Ribeiro, P. J., Bonat, W. H., Shimakura, S. E.,
#'     Muniz, J. A. (2014). The Gamma-count distribution in the analysis
#'     of experimental underdispersed data. \strong{Journal of Applied
#'     Statistics}, 41(12), 1–11.
#'     \url{http://doi.org/10.1080/02664763.2014.922168},
#'     \url{http://leg.ufpr.br/doku.php/publications:papercompanions:zeviani-jas2014}.
#' @examples
#'
#' library(lattice)
#' library(latticeExtra)
#'
#' data(cotton_defol)
#' str(cotton_defol)
#'
#' # x11(width = 7, height = 2.8)
#' xyplot(bolls ~ defol | phenol,
#'        data = cotton_defol,
#'        layout = c(NA, 1),
#'        type = c("p", "smooth"),
#'        xlab = "Artificial defoliation level",
#'        ylab = "Number of bolls produced",
#'        xlim = extendrange(c(0:1), f = 0.15),
#'        jitter.x = TRUE)
#'
#' # Sample mean and variance in each treatment cell.
#' mv <- aggregate(bolls ~ phenol + defol,
#'                 data = cotton_defol,
#'                 FUN = function(x) {
#'                     c(mean = mean(x), var = var(x))
#'                 })
#' str(mv)
#'
#' xlim <- ylim <- extendrange(c(mv$bolls), f = 0.05)
#'
#' # Evidence of underdispersion.
#' xyplot(bolls[, "var"] ~ bolls[, "mean"],
#'        data = mv,
#'        grid = TRUE,
#'        aspect = "iso",
#'        type = c("p", "r"),
#'        xlim = xlim,
#'        ylim = ylim,
#'        ylab = "Sample variance",
#'        xlab = "Sample mean") +
#'     layer(panel.abline(a = 0, b = 1, lty = 2))
#'
NULL
