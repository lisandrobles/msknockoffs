#' Main selection function
#'
#' This function calculates knockoffs, Z and Z-knockoff statistics,
#' creates a combination of all knockoffs, and calculates W statistics
#' and the threshold. Finally, it returns a selection of variables.
#'
#' @param Xlist list of length K for predictor matrices from each experiment
#' @param Ylist list of length K for outcomes from each experiment
#' @param familylist vector of length K for type of outcomes from each experiment (Binomial)
#' @param Kmethod vector of length K for knockoff construction methods for each experiment
#' @param Zmethod vector of length K for Z statistics calculation methods for each experiment. Current implemented method is glmnet
#' @param q FDR level for control
#' @param offset 1 for Knockoff+
#' @param Wmethod OSFF W method, W statistics
#' @returns A list of selected variables indices
#' @export


selection <- function(Xlist,Ylist,familylist,Kmethod,Zmethod,q,offset,Wmethod){
  XKnock <- knockoffs_creation(Xlist,Kmethod)

  Z <- z_statistics(Xlist,Ylist,Zmethod,familylist,XKnock)$Z
  Ztilde <- z_statistics(Xlist,Ylist,Zmethod,familylist,XKnock)$Ztilde

  Z_com <- osff_comb(Xlist,Z,Ztilde)$Z_com
  Ztilde_com <- osff_comb(Xlist,Z,Ztilde)$Ztilde_com

  W <- w_statistics(Xlist,Wmethod,Z,Ztilde,Z_com,Ztilde_com)

  my_selection <- threshold(W,q,offset)
  return(my_selection)
}
