<img src = "https://github.com/JrEduardo/gammacount/raw/master/gammacount.png" width=150px align="right" display="block">

# Gamma-count Regression Models for Dispersed Count Data #

[![Build Status](https://travis-ci.org/JrEduardo/gammacount.svg?branch=master)](https://travis-ci.org/JrEduardo/gammacount)

[Eduardo E. R. Junior](http://jreduardo.github.io/)<sup>1</sup>
([`edujrrib@gmail.com`](mailto:edujrrib@gmail.com)) &
[Walmes M. Zeviani](www.leg.ufpr.br/~walmes/)<sup>1</sup>
([`walmes@ufpr.br`](mailto:walmes@ufpr.br))

<sup>1</sup>Paraná Federal University, Laboratory of Statistics and
Geoinformation (LEG/UFPR)

## Description ##

The `gammacount` is a package with functions to apply regression models
to count data using the [Gamma-Count] distribution. A likelihood-based
approach is used for parameter estimation and inference through a S4
implementation derived from [`bbmle`] package. The Gamma-count
regression model is considered in this package and methods for this
model are also provided. See the [supplementary material] of
[Zeviani et. al (2014)] for and old state version of the functions.

## Download and Install ##

The `gammacount` is developed under control version using [Git] and is
hosted in [GitHub]. You can install automatically from the GitHub
repository using
[`devtools`](https://cran.r-project.org/web/packages/devtools/). Just
run the code below in a R session.

```r
# install.packages("devtools")
devtools::install_git("git@github.com:JrEduardo/gammacount.git")
devtools::install_github("JrEduardo/gammacount") ## For short.
```

After installing the package, you can load and explore its contents
running the R code below.

```r
# Load and explore the package.
library(gammacount)
packageVersion(gammacount)
ls("package:gammacount")
help(package = "gammacount")
```

## License ##

The `gammacount` package is licensed under the
[GNU General Public License, version 3], see the [`LICENSE`](./LICENSE)
file.

<!-- Hyperlinks ----------------------------- -->
[Git]: https://git-scm.com/
[GitHub]: https://github.com/JrEduardo/gammacount
[GNU General Public License, version 3]: https://www.gnu.org/licenses/gpl-3.0.html
[`bbmle`]: https://cran.r-project.org/web/packages/bbmle/index.html
[Zeviani et. al (2014)]: http://www.tandfonline.com/doi/abs/10.1080/02664763.2014.922168?journalCode=cjas20
[supplementary material]: http://www.leg.ufpr.br/~walmes/papercompanions/gammacount2014/papercomp.html
[Gamma-Count]: https://www.jstor.org/stable/1392392
