#' Creation of knockoffs
#' This function create knockoffs using sequential or second order method
#'
#' @param Xlist List of length K of the predictor matrix for each experiment
#' @param Kmethod Vector of length K for the type of knockoff construction
#'
#' @returns A list of length K of the knockoff matrices
#'
#' @importFrom seqknockoff knockoffs_seq
#' @importFrom knockoff create.second_order
#'
#' @export

knockoffs_creation <- function(Xlist,Kmethod){
X <- list()
Xc<-list()
XKnock <- list()
K <- length(Xlist)

for (k in seq_along(Xlist)){
  if (Kmethod[k]=="sequential"){
    XKnock[[k]]<-knockoffs_seq(Xlist[[k]])
  }
  if (Kmethod[k]=="second"){
    X[[k]]=as.matrix(Xlist[[k]])
    Xc[[k]]<-X[[k]]%*%diag(1/sqrt(colSums(X[[k]]^2)))
    XKnock[[k]]<-create.second_order(Xc[[k]],shrink=T)
    XKnock[[k]]=as.data.frame(XKnock[[k]])
  }
}
return(XKnock)
}
