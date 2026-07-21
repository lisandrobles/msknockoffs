#' n selections
#'
#' This function make n repetitions or selections of the function selection(),
#'  filter all n with a heuristic rule and returns a single selection.
#'
#' @param n Number of repetitions or selections to be done
#' @param Xlist list of length K for predictor matrices from each experiment
#' @param Ylist list of length K for outcomes from each experiment
#' @param familylist vector of length K for type of outcomes from each experiment (Binomial)
#' @param Kmethod vector of length K for knockoff construction methods for each experiment
#' @param Zmethod vector of length K for Z statistics calculation methods for each experiment. Current implemented method is glmnet
#' @param q FDR level for control
#' @param offset 1 for Knockoff+
#' @param Wmethod OSFF W method, W statistics
#'
#' @returns A vector of selected indices
#'
#' @importFrom clustermq Q
#' @importFrom seqknockoff multi_select
#'
#' @export
#'
n_selection <- function(n,Xlist,Ylist,familylist,Kmethod,Zmethod,q,offset,Wmethod){

  p = ncol(Xlist[[1]])
  S <- Q(
    selection,
    q = rep(q,n),
    const = list(Xlist=Xlist,Ylist=Ylist,familylist=familylist,Kmethod=Kmethod,
                 Zmethod=Zmethod,offset=offset,Wmethod=Wmethod),
    n_jobs = n)


  selection_of_indices <- multi_select(S, p)
  return(selection_of_indices)
}
