
<!-- README.md is generated from README.Rmd. Please edit that file -->

# msknockoffs

<!-- badges: start -->

<!-- badges: end -->

_msknockoffs_ stands for multi-study knockoffs. This package is very useful to get
a set of variables that are associated with a response $y$. The package
contains a main algorithm that is able to use $K$ datasets of gene
expression data, it calculates knockoffs from two methods (sequential
and second-order), $Z$ and $Z$-knockoff statistics of the $K$ datasets,
creates a combination of all knockoffs with help of OSCF function,
calculates $W$ statistics and a threshold, finally returns a
selection of variables.

A complete tesis of this study can be found [here](http://tesiuami.izt.uam.mx/uam/aspuam/presentatesis.php?recno=223280006753712&docs=2232800067_537.pdf).

## Installation

You can install the development version of msknockoffs like so:

``` r
# install.packages("devtools")
devtools::install_github("lisandrobles/msknockoffs")
```

## Use of the X-model of knockoffs for the identification of cancer diagnostic genes from considering lung gene expression data from multiple sources.

This example illustrates the main function. We are using three datasets
that contain gene expression information related to lung cancer. The
objective of this example is to show that this algorithm can obtain a
set of variables, and identifying these variables helps us understand
which gene expressions are most associated with lung cancerous tissue;
furthermore, it also allows us to create a classification model between
healthy and tumorous tissue. Also this algorithm can control FDR.

First load the necessary libraries:

``` r
#install.packages("knockoff")
library(knockoff)
#devtools::install_github("kormama1/seqknockoff")
library(seqknockoff)
#install.packages("glmnet")
library(glmnet)
```


``` r
#install.packages("clustermq")
library(clustermq)
```

``` r
#devtools::install_github("lisandrobles/msknockoffs")
library(msknockoffs)
```

Getting the data ready

``` r
data1 <- read.csv("data/18_Lu_2010_100.csv",header = TRUE)
data2 <- read.csv("data/36_Selamat_2012_100.csv",header = TRUE)
data3 <- read.csv("data/2_Landi_2008_100.csv",header = TRUE)
```

Here we need to set out the parameters that the main function needs. In
the R console write ?selection to see this function documentation and
usage.

``` r
Xlist <- list(data1[,-c(1)],data2[,-c(1)],data3[,-c(1)])
Ylist <- list(data1$Sam_Tissue,data2$Sam_Tissue,data3$Sam_Tissue)
familylist=c("binomial","binomial","binomial")
Kmethod=c("second","second","second")
Zmethod=c("glmnet","glmnet","glmnet")
Wmethod="D_Max_Sum"
q = 0.2
offset = 1
```

This algorithm is very flexible, you can use the number of dataset you
like, select different methods for calculating knockoffs, diferent W
functions, etc.

Then we call the main function, this function calculates knockoffs, Z
and Z-knockoff statistics, creates a combination of all knockoffs, and
calculates W statistics and the threshold. Finally, it returns a
selection of variables.

``` r
selection_of_indices <- selection(Xlist,Ylist,familylist,Kmethod,Zmethod,q,offset,Wmethod)
```

The function gene_id() is very useful to get the name id of indices.

``` r
gene_id_selection <- gene_id(selection_of_indices,q,data1)
```

    ## [1] "Found 37 indices with FDR= 0.2 ,ID of genes are:"
    ##  [1] "1003"   "1048"   "11170"  "125"    "1277"   "1311"   "1382"   "1469"  
    ##  [9] "1675"   "177"    "2167"   "2327"   "27074"  "3043"   "3569"   "3934"  
    ## [17] "4499"   "4973"   "51208"  "6279"   "6286"   "6690"   "6696"   "7049"  
    ## [25] "7058"   "7103"   "7134"   "729238" "7433"   "762"    "8547"   "857"   
    ## [33] "9244"   "9245"   "948"    "9510"   "9518"

This indices can be found and study in [web page](https://www.ncbi.nlm.nih.gov/) from USA goverment.

Another important function in this package is the function that can make
a number of $n$ selections, that is, you can run, for example, fifty times
the function, this give a set fifty selections, then using a rule propose in Kormaksson et al., 2021,
we get a final set of indices or variables.

``` r
n_selection_of_indices <- n_selection(n=50,Xlist,Ylist,familylist,Kmethod,Zmethod,q,offset,Wmethod)
```

Using the gene_id function

``` r
n_gene_id_selection <- gene_id(n_selection_of_indices,q,data1)
```

    ## [1] "Found 24 indices with FDR= 0.2 ,ID of genes are:"
    ##  [1] "1003"   "1048"   "11170"  "1311"   "1382"   "1469"   "177"    "2167"  
    ##  [9] "2327"   "2920"   "3043"   "3569"   "4318"   "4499"   "51208"  "6696"  
    ## [17] "7049"   "7103"   "7134"   "729238" "762"    "8685"   "9245"   "9518"

That is our selected indices, those indices can be studied in [web page](https://www.ncbi.nlm.nih.gov/).
