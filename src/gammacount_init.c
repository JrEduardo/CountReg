#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP gammacount_qgcnt_iid(SEXP, SEXP, SEXP);
extern SEXP gammacount_qgcnt_one(SEXP, SEXP, SEXP);
extern SEXP gammacount_rgcnt_iid(SEXP, SEXP, SEXP);
extern SEXP gammacount_rgcnt_one(SEXP, SEXP);
extern SEXP gammacount_rgnzp_esc(SEXP, SEXP, SEXP);
extern SEXP gammacount_rgnzp_vec(SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"gammacount_qgcnt_iid", (DL_FUNC) &gammacount_qgcnt_iid, 3},
    {"gammacount_qgcnt_one", (DL_FUNC) &gammacount_qgcnt_one, 3},
    {"gammacount_rgcnt_iid", (DL_FUNC) &gammacount_rgcnt_iid, 3},
    {"gammacount_rgcnt_one", (DL_FUNC) &gammacount_rgcnt_one, 2},
    {"gammacount_rgnzp_esc", (DL_FUNC) &gammacount_rgnzp_esc, 3},
    {"gammacount_rgnzp_vec", (DL_FUNC) &gammacount_rgnzp_vec, 3},
    {NULL, NULL, 0}
};

void R_init_gammacount(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
