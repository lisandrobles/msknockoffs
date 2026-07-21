#' Threshold of the knockoff filter
#'
#' @param W A vector of length p, W statistics
#' @param q Level of control of the FDR
#' @param offset 1 for Knockoff+
#'
#' @importFrom knockoff knockoff.threshold
#'
#' @returns A vector of selected indices
#' @export
#'
threshold <- function(W,q,offset){

  mythred=knockoff.threshold(W,fdr=q,offset=offset)
  selection=which(W>=mythred)

  return(selection)
}
