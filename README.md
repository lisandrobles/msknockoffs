
<!-- README.md is generated from README.Rmd. Please edit that file -->

# msknockoffs

<!-- badges: start -->

<!-- badges: end -->

msknockoffs stands for multi-study knockoffs. This package helps to get
a set of variables that are associated with a response $y$. The package
contains a main algorithm that is able to use $K$ datasets of gene
expression data. It calculates knockoffs from two methods (sequential
and second-order), $Z$ and $Z$-knockoff statistics of the $K$ datasets,
creates a combination of all knockoffs with help of OSFF function,
calculates $W$ statistics and the threshold, and finally returns a
selection of variables.

## Installation

You can install the development version of msknockoffs like so:

``` r
# install.packages("devtools")
devtools::install_github("lisandrobles/msknockoffs")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(msknockoffs)
## basic example code
```
