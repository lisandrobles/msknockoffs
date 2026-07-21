#' Z and ZKnock statistics
#'
#' This function calculates the Z and Zknockoff values, i.e.,
#' the absolute values of the LASSO regression coefficients.
#'
#' @param Xlist list of length K for predictor matrices from each experiment
#' @param Ylist list of length K for outcomes from each experiment
#' @param Zmethod vector of length K for knockoff construction methods for each experiment
#' @param familylist vector of length K for type of outcomes from each experiment (Binomial)
#' @param XKnock A list of length K of the knockoff matrices
#'
#' @returns Two lists Z and Ztilde, absolute values of the LASSO regression coefficients.
#'
#' @importFrom stats model.matrix rbinom coef
#' @importFrom glmnet glmnet
#'
#' @export

z_statistics <- function(Xlist,Ylist,Zmethod,familylist,XKnock){
Z <- list()
Ztilde <- list()

for (k in seq_along(Xlist)){
  if (Zmethod[k]=="glmnet"){
    if (familylist[k]=="binomial"){
      x <- model.matrix(~., data=Xlist[[k]])[,-1]
      x_k <- model.matrix(~., data=XKnock[[k]])[,-1]

      Xlist[[k]]=x; XKnock[[k]]=x_k
      family=familylist[[k]]

      swap = rbinom(ncol(Xlist[[k]]),1,0.5)
      swap.M = matrix(swap,nrow=nrow(Xlist[[k]]),ncol=length(swap),byrow=TRUE)
      X.swap  = Xlist[[k]] * (1-swap.M) + XKnock[[k]] * swap.M
      Xk.swap = Xlist[[k]] * swap.M + XKnock[[k]] * (1-swap.M)

      # Number of predictors
      p = ncol(Xlist[[k]])

      nlambda=500;intercept=T;parallel=F

      Xz=cbind(X.swap, Xk.swap)

      # Estandarize variables
      Xz = scale(Xz)
      n = nrow(Xlist[[k]]); p = ncol(Xlist[[k]])

      # cv.glmnet Does k-fold cross-validation for glmnet, returns a value for lambda
      #alpha=1 es LASSO
      cv.glmnet.fit <- glmnet::cv.glmnet(Xz, Ylist[[k]], lambda=NULL, alpha=1,
                                         standardize=F,standardize.response=F, parallel=parallel)

      #coefficients from regression
      glmnet.coefs<-coef(cv.glmnet.fit, s = "lambda.min")

      #Selection Z and ZKnock
      all_Z=abs(glmnet.coefs[2:(2*p+1)])
      Z[[k]]=abs(all_Z[1:p])
      Ztilde[[k]]=abs(all_Z[(p+1):(2*p)])

    }
  }
}
return(list(Z = Z, Ztilde = Ztilde))
}
