#include <math.h>
#include <R.h>
#include <Rmath.h>
#include <Rcpp.h>
using namespace Rcpp;

//----------------------------------------------------------------------

/*
  A função `qgcnt_esc` é vetorial em `q` mas é escalar em `lambda` e
  `alpha`, portanto é para ser usada no caso iid. Ela assume que os
  valores no vetor `q` estão ordenados para com isso "subir e escada" da
  função acumulada na busca pelos quantis apenas uma vez. Isso confere
  ganho computacional quando o vetor `q` é na realizade um vetor de
  números uniformes usado para geração de números aleatórios.
*/

// [[Rcpp::export(name = ".qgcnt_iid")]]
IntegerVector qgcnt_iid(NumericVector p,
                        double lambda,
                        double alpha) {
  int n = p.size();
  IntegerVector x(n);
  double alphalambda;
  alphalambda = 1/(alpha * lambda); // R::pgamma() uses scale.

  int z;
  double gl, gr, px, Px;
  z = 0;
  gl = 1;
  // double R::pgamma(double x, double alp, double scl, int lt, int lg).
  gr = R::pgamma(1, alpha, alphalambda, 1, 0);
  px = gl - gr;
  Px = px;

  int i;
  for (i = 0; i < n; i++) {
    while (p[i] >= Px) {
      gl = gr;
      z = z + 1;
      gr = R::pgamma(1, (z + 1) * alpha, alphalambda, 1, 0);
      px = gl - gr;
      Px = Px + px;
    }
    x[i] = z;
  }

  // Rcpp::Rcout << x << std::endl;
  return x;
}

//----------------------------------------------------------------------

/*
  A função qgcnt_one() trabalha todos os argumentos de forma
  escalar. Ela foi feita para ser usada com mapply(). Deve ser utilizada
  no caso não iid onde vetores de `lambda` e `alpha` são passados.
*/

// [[Rcpp::export(name = ".qgcnt_one")]]
int qgcnt_one(double p,
              double lambda,
              double alpha) {
  double alphalambda;
  alphalambda = 1/(alpha * lambda);
  int x;
  x = 0;
  double gl, gr, px, Px;
  gl = 1;
  gr = R::pgamma(1, alpha, alphalambda, 1, 0);
  Px = px = gl - gr;
  while (Px < p) {
    gl = gr;
    x = x + 1;
    gr = R::pgamma(1, (x + 1) * alpha, alphalambda, 1, 0);
    px = gl - gr;
    Px = Px + px;
  }
  return x;
}

//----------------------------------------------------------------------
// Funções para geração de números aleatórios.

/*
  A função rgcnt_one() gera apenas um número aleatório pois essa função
  é escalar em todos os argumentos. Ela chama a função qgcnt_one().
*/

// [[Rcpp::export(name = ".rgcnt_one")]]
int rgcnt_one(double lambda,
              double alpha) {
  double u;
  u = R::runif(0.0, 1.0);
  int x;
  x = qgcnt_one(u, lambda, alpha);
  return x;
}

/*
  A função rgcnt_iid() gera um vetor de números aleatórios de tamanho
  `n`. Ela é escalar nos parâmentros `lambda` e `alpha` e usa um vetor
  ordenado de números uniformes para "subir a escala" apenas uma
  vez. Ela usa a função qgcnt_idd().
*/

// [[Rcpp::export(name = ".rgcnt_iid")]]
IntegerVector rgcnt_iid(int n,
                        double lambda,
                        double alpha) {
  IntegerVector x(n);
  NumericVector u(n);
  u = Rcpp::runif(n);
  std::sort(u.begin(), u.end());
  x = qgcnt_iid(u, lambda, alpha);
  // Rcpp::Rcout << u << std::endl;
  std::random_shuffle(x.begin(), x.end());
  return x;
}

//----------------------------------------------------------------------
// Função densidade.

// // [[Rcpp::export(name = ".dgcnt_one")]]
// double dgcnt_one(int x,
//                  double lambda,
//                  double alpha,
//                  int lg) {
//   double alphalambda, px;
//   alphalambda = 1/(alpha * lambda);
//   px = R::pgamma(1, x * alpha, alphalambda, 1, 0) -
//     R::pgamma(1, (x + 1) * alpha, alphalambda, 1, 0);
//   if (lg) {
//     if (px == 0) {
//       px = -744.440072;
//     } else {
//       px = std::log(px);
//     }
//   }
//   return px;
// }
