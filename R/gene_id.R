#' Id of genes
#'
#'This function extract id genes names from datasets
#'
#' @param selection_of_indices A vector of selected indices
#' @param q FDR level for control
#' @param data1 A data set in use
#'
#' @returns Id of selected genes
#' @export
#'
gene_id <- function(selection_of_indices,q,data1){
  sele_mult_vec<-c(selection_of_indices)
  name_col <- colnames(data1[,-c(1)])[sele_mult_vec]
  name_col <- gsub("X", "", name_col)

  print(paste("Found",length(selection_of_indices),
              "indices with FDR=",q,",ID of genes are:"))
  print(name_col)
  return(name_col)
}
