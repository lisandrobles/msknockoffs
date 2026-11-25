#' Combination of all Z an Ztilde statistics
#'
#' This function combines all the information of all Z and Z statistics
#' from all dataset, use of a osff to combine.
#'
#' @param Xlist List of length K of the predictor matrix for each experiment
#' @param Z A list of all Z statistics, first (1,p) absolute values of the LASSO regression coefficients.
#' @param Ztilde A list of all Ztilde statistics, first (p+1,2p), absolute values of the LASSO regression coefficients.
#'
#' @returns Two vectors, Z_com and Ztilde_com
#' @export
#'
oscf_comb <- function(Xlist,Z,Ztilde){

  K <- length(Xlist)
  A <- as.matrix(expand.grid(rep(list(c(0, 1)), K)))

  # Calculo de residuos
  rpar <- K %% 2
  rimpar <- (K + 1) %% 2

  # Agregar a Aimpar y Apar
  Apar <- matrix(numeric(0), ncol = ncol(A))
  Aimpar <- matrix(numeric(0), ncol = ncol(A))

  for (i in seq(2**K)) {
    if ((norm(as.matrix(A[i, ]), type = "1")) %% 2 == rpar) {
      Apar <- rbind(Apar, A[i, ])
    } else {
      Aimpar <- rbind(Aimpar, A[i, ])
    }
  }

  Z_com = 0
  for (i in seq(K)) {
    prod = 1
    for (k in seq(K)) {
      a = Z[[k]]^(Apar[i,k])*Ztilde[[k]]^(1-Apar[i,k])
      prod = prod * a
    }
    Z_com = Z_com + prod
  }


  Ztilde_com = 0
  for (i in seq(K)) {
    prod = 1
    for (k in seq(K)) {
      a = Z[[k]]^(Aimpar[i,k])*Ztilde[[k]]^(1-Aimpar[i,k])
      prod = prod * a
    }
    Ztilde_com = Ztilde_com + prod
  }
return(list(Z_com=Z_com, Ztilde_com=Ztilde_com))
}
