# EM algorithm for fitting hidden markov model with 3 Gaussian emission probabilities with known covariance matrix to bivariate data
# Parameters to be estimated: xi =  (A, a0, mu1, mu2,mu3, pi1,  pi2)
# A 3rd party implementation is used to compute the responsibilities in the E-step (the RHmm package).This package is available on CRAN and must be installed for this code to compile.

# INPUTS
# y (NxP matrix) = random sample to which we fit the MM
# maxIt (integer) = max number of iterations for EM algorithm

#OUTPUTS
# p (list) = containing MLE estimate of the transition matrix (3x3), initial probabilities (1x3), and means (3xp matrix)

fitHMM <- function(y, maxIt=300){
  
library(mvtnorm)  
library(RHmm)

# algorithm parameters
p<-NULL
S <- 3 # mixture complexity
T <- nrow(y) #number of observations

e1s <- array(dim=c(1,S))
ets<-array(dim=c(T,S)) # p(obsevration t being in state s)
etij<-array(dim=c(S,S, T)) #p(transitioning from state i to j)


# initialization 
  mu = matrix(runif(K*2, min=0, max=12), nrow=K) #sample mu0 uniformly over [0,12]x[0,12]
  
  # sample a0, A uniformly, respecting the convexity constraint
  
  #a0 <- rep(1/S, S) # initial state
  #a0 <- c(0.2,0.6,0.2)
  a0 <- c(0,0,1)
  A <- matrix(rep(1/S, S^2), nrow=S)
  sigma <- diag(2)
  
  for (it in 1:maxIt){
    # E- Step           
    ker <- distributionSet("NORMAL", mean=list(mu[1,], mu[2,], mu[3,]),cov=list(sigma,sigma, sigma))
    fb <- forwardBackward(HMMSet(a0, A, ker),y)
    ets <- fb$Gamma  
    etij <- fb$Xsi
    etij[[T]] <- NULL
    
    for (s in 1:S)
      e1s[s] <- a0[s]*dmvnorm(y[1,], mu[s,], sigma)/dGMM(y[1,],a0,mu,sigma)    
    
    print(e1s)
    # M-Step  
    #a0<- ets[1,]/sum(ets[1,])
    a0 <- as.vector(e1s/sum(e1s))
    
    A <- Reduce("+", etij) #sum across all observations
    A<-A/rowSums(A) # normalize       
    
    Ns <- colSums(ets)  
    mu <- t(ets) %*% y / Ns #mle for mean
  }  
return(list(A, a0, mu))
}
