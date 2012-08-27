# 6631 Applied Statistics II Final Project Code
# Alex Yakubovich
# April 11, 2012

# part 1) generate a sample from a gaussian mixture model, corrupt it with noise and fit the GMM usingt the EM algorithm

# part 2) generate a sequence of observations from a hidden markov model, corrupt it with noise and fit the HMM usingt the EM algorithm for HMM. A 3rd party implementation is used to compute the responsibilities in the E-step (the RHmm package)

setwd("/Users/alexyakubovich/Desktop/6631/Project")

# 1) mixture model
source("genMM.r")
source("fitMM.r")
source("dGMM.r") 
y1<-genMM(N=100, vis=1)
y1<- y1+ rmvnorm(100, mean=c(0,0), sigma=diag(2)) # corrupt with iid zero mean isotropic gaussian noise
fitMM(y1, maxIt=200)

# 2) hidden markov model
source("genHMM.r")
source("fitHMM.r")

y2 <- genHMM(N=100, vis=1)
y2 <- y2 + rmvnorm(100, mean=c(0,0), sigma=diag(2)) # corrupt with iid zero mean isotropic gaussian noise
fitHMM(y2, maxIt=200)
#lines(ellipse(sigma,centre=mu[2,], level=c(0.95, .9), col='green')