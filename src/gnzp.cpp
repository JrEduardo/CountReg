#include <Rcpp.h>
// #include <R.h>
// #include <Rmath.h>
#include <algorithm>

using namespace Rcpp;

//----------------------------------------------------------------------

/*
  Sort elements of a vector x.
 */

NumericVector stl_sort(NumericVector x) {
   NumericVector y = clone(x);
   std::sort(y.begin(), y.end());
   return y;
}

//----------------------------------------------------------------------

/*
  Essa função retorna a razão de probabilidades consecutivas
  h(x) = Pr(X == x)/Pr(X == x - 1), x > 1. Ela é utilizada para calcular
  probabilidades acumuladas.
 */

double hx_gnzp(int x, double lambda, double alpha) {
  double z, w0, w1, alphalambda;
  alphalambda = alpha * lambda;
  z = 1 + alphalambda;
  w0 = 1 + alpha * x;
  w1 = 1 + alpha * (x - 1);
  return (lambda/z) * pow(w0, (x - 1)) * pow(w1, (2 - x)) *
    exp(-alphalambda/z)/x;
}

//----------------------------------------------------------------------

/*
  Função para geração de números aleatórios para lambda e alpha
  escalares. A função wrapper deve testar o tamanho de lambda e alpha
  para decidir que função usar.
 */

// [[Rcpp::export(name=".rgnzp_esc")]]
IntegerVector rgnzp_esc(int n,
                        double lambda,
                        double alpha) {
  NumericVector u(n);
  IntegerVector x(n);
  u = Rcpp::runif(n);
  u = stl_sort(u);

  double px, Px, alphalambda;
  alphalambda = alpha * lambda;
  px = exp(-lambda/(1 + alphalambda));
  Px = px;

  int z, i, j;
  i = 0;
  z = 0;
  while (u[i] <= Px) {
    x[i] = z;
    i = i + 1;
  }

  // Pr(X <= 1) = Pr(X == 0) + Pr(X == 1).
  z = 1;
  px = lambda/(1 + alphalambda) *
    exp(-lambda * (1 + alpha)/(1 + alphalambda));
  Px = Px + px;
  // Valores de X iguais a 1 pois U <= Pr(X <= 1).
  while (u[i] <= Px) {
    x[i] = z;
    i = i + 1;
  }

  z = 2;
  px = px * hx_gnzp(z, lambda, alpha);
  Px = Px + px;
  for (j = i; j < n ; j++) {
    x[j] = z;
    if (u[j] <= Px) {
      continue;
    } else {
      // P(X = x), where x is greater then 1.
      z = z + 1;
      px = px * hx_gnzp(z, lambda, alpha);
      Px = Px + px;
    }
  }

  // Does permutation like R function sample().
  std::random_shuffle(x.begin(), x.end());
  return x;
}

//----------------------------------------------------------------------

/*
  Função para geração de números aleatórios para lambda e alpha
  vetores. A função wrapper deve testar o tamanho de lambda e alpha para
  decidir que função usar.
 */

// [[Rcpp::export(name=".rgnzp_vec")]]
IntegerVector rgnzp_vec(int n,
                        NumericVector lambda,
                        NumericVector alpha) {
  NumericVector u(n);
  u = Rcpp::runif(n);
  IntegerVector x(n);

  int i, z;
  double px, Px;
  NumericVector alphalambda;
  alphalambda = alpha * lambda;

  for (i = 0; i < n ; i++) {

    // Pr(X <= 0) = Pr(X == 0).
    z = 0;
    px = exp(-lambda[i]/(1 + alphalambda[i]));
    Px = px;
    if (u[i] <= Px) {
      x[i] = z;
      continue;
    }

    // Pr(X <= 1) = Pr(X == 0) + Pr(X == 1).
    z = 1;
    px = lambda[i]/(1 + alphalambda[i]) *
      exp(-lambda[i] * (1 + alpha[i])/(1 + alphalambda[i]));
    Px = Px + px;
    // Valores de X iguais a 1 pois U <= Pr(X <= 1).
    if (u[i] <= Px) {
      x[i] = z;
      continue;
    }

    while (u[i] > Px) {
      z = z + 1;
      px = px * hx_gnzp(z, lambda[i], alpha[i]);
      Px = Px + px;
      x[i] = z;
    }

  } // for ()

  return x;
}
