
# Generate a sequence of observations from a Hidden Markov Model with specified transition matrix, initial probabilities, and set of 3 bivariate nomral emission probabilities with common convariance.

# INPUTS
# N = size of sample
# mu = mean of multivariate normal kernel
# sigma = covariance matrix of multivariate normal kernel
# p = vector of initial probabilities
# A = transition matrix
# vis = option to visulize the generating process (=1 for yes, = 0 for no)

# OUTPUT
# y = generated sequence of observations

genHMM <-function(N=200, mu, sigma, p, A, vis=1){

library(MASS)
set.seed(10)

# INITIALIZATION
nstates <- 3
z<-mat.or.vec(N, nstates)
y<-mat.or.vec(N,2)

# simulate observations

# generate and plot 1st point 
z[1,] <- t(rmultinom(1, size=1, prob = p))
y[1,] <- mvrnorm(1, mu[z[1,]==1], sigma)
if (vis) {
  plot(y[1,1], y[1,2], xlim=c(-5,10), ylim=c(-5,15), col = which(z[1,]>0) + 1, pch=16, xlab='x', ylab='y')
}
# generate rest of observations
for (i in 2:N){
  prev_state <- which(z[i-1, ]>0)
  z[i,] <- t(rmultinom(1, size=1, prob = A[prev_state, ])) # generate (y,z)
  y[i,] <- mvrnorm(1, mu[z[i,]==1], sigma)
    
  if (vis){  
    Sys.sleep(.5)
    points(y[i,1], y[i,2], col=which(z[i,]>0) + 1, pch=16) #plot y
    segments(x0=y[i-1,1], y0=y[i-1,2], x1=y[i,1], y1=y[i,2], new=T) #plot line joining yn, yn-1
  }
}
return(y)
}