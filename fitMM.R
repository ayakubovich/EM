# EM algorithm for fitting mixture model with 3 Gaussian kernels and known variance to  bivariate data.
# Parameters to be estimated: xi =  (mu1, mu2,mu3, pi1,  pi2)

# INPUTS
# y (NxP matrix) = random sample to which we fit the MM
# maxIt (integer) = max number of iterations for EM algorithm

#OUTPUTS
# p (list) = containing MLE estimate of the means (3xp matrix) and proportions (1x3) vector

fitMM <- function(y, maxIt=200){

  library(mvtnorm)
  
  # algorithm parameters
  # maxIt<-200 # maximum number of iterations
  K<-3 # mixture complexity
  N<-nrow(y)
  enk <- matrix(nrow=N, ncol=K)
  
  # initialization 
  mu = matrix(runif(K*2, min=0, max=12), nrow=K) #sample mu0 uniformly over [0,12]x[0,12]
  p <- rep(1/K, times=K) # mix. coefficients equal for all components
  sigma <- diag(2)
  
  for (it in 1:maxIt){
    # E- Step    
    for (j in 1:K)
      enk[,j] <- p[j]*dmvnorm(y, mu[j,], sigma)/dGMM(y,p,mu,sigma)     
    
    # M-Step  
    Nk <- colSums(enk)  
    mu <- t(enk) %*% y / Nk
    p <- Nk/N
  }
  return(list(mu,p))
}