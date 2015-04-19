library(mvtnorm)
library(MASS)
library(RHmm)

# 1) generate a sample from a gaussian mixture model, corrupt it with noise and fit the GMM using the EM algorithm
source("genMM.R")
source("fitMM.R")
source("dGMM.R") 

N <- 100 # number of points to sample
niterations <- 200 #number of iterations in EM algorithm

# specify parameters of gaussian mixture model
mu <- matrix(c(0,0, 0,12, 6,6),3, byrow=T) #means of multivariate normal kernels
sigma <- diag(c(1,1)) # common covariance matrix
p <- c(.2, .2, .6)  #mixing proportions

y1 <- genMM(N, mu, sigma, p, vis=1) # generate data from a gaussian mixture model
y1 <- y1+ rmvnorm(N, mean=c(0,0), sigma=diag(2)) # corrupt with iid zero mean isotropic gaussian noise
fitMM(y1, niterations)

####
# 2) Generate a sequence of observations from a Hidden Markov Model
source("genHMM.R")
source("fitHMM.R")

# use same multivariate kernels as before, but add a diagonal-heavy transition matrix
A <- matrix(c(c(.8,.1,.1), c(.1,.8,.1), c(.1, .1, .8)),3, byrow=T) # transition matrix
y2 <- genHMM(N, mu, sigma, p, A, vis=1)
fitHMM(y2, maxIt=200)