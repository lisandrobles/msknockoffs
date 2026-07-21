#' Calculates W statistics
#'
#' This function implements five diferent functions for calculating
#' W statistics
#'
#' @param Xlist list of length K for predictor matrices from each experiment
#' @param Wmethod OSFF W method, W statistics
#' @param Z A list of all Z statistics, first (1,p) absolute values of the LASSO regression coefficients.
#' @param Ztilde A list of all Ztilde statistics, first (p+1,2p), absolute values of the LASSO regression coefficients.
#' @param Z_com A vector of length p with combinations of all Z statistics
#' @param Ztilde_com A vector of length p with combinations of all Ztilde statistics
#'
#' @returns A vector of length p, W statistics
#' @export
#'
w_statistics <- function(Xlist,Wmethod,Z,Ztilde,Z_com,Ztilde_com){

  p <- ncol(Xlist[[1]])
  K <- length(Xlist)

  if (Wmethod=="Diff"){
    W=rep(1,p)
    for (k in 1:K){
      W=W*(Z[[k]]-Ztilde[[k]])
    }
  }
  if (Wmethod=="D_Max_Sum"){
    W<- rep(0,p)
    for (k in 1:K){
      W<-W+pmax(Z[[k]],Ztilde[[k]])*(-1)^(Z_com<Ztilde_com)
    }
  }
  if (Wmethod=="Max"){
    W=pmax(Z_com,Ztilde_com)*(-1)^(Z_com<Ztilde_com)
  }
  if (Wmethod=="Diff_2"){
    W=Z_com-Ztilde_com
  }
  if (Wmethod=="D_Max_Max"){
    W<- rep(0,p)
    for (k in 1:K) {
      W=pmax(W,Z[[k]],Ztilde[[k]])
    }
    W=W*(-1)^(Z_com<Ztilde_com)
  }
return(W)
}
