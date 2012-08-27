
# Generate a sequence of observations from a Hidden Markov Model with specified transition matrix, initial probabilities, and set of 3 bivariate nomral emission probabilities with common convariance.

# INPUTS
# N = size of sample
# vis = option to visulize the generating process (=1 for yes, = 0 for no)

# OUTPUT
# y = generated seauence of observations

genHMM<-function(N=200, vis=1){

library(MASS)
set.seed(10)

# INITIALIZATION
nstates <- 3
z<-mat.or.vec(N, nstates)
y<-mat.or.vec(N,2)

# mean and (common) covariance for the 3 multivariate normal kernels
mu <- matrix(c(0,0, 0,12, 6,6),3, byrow=T) 
sigma <- diag(c(1,1)) 

# transition matrix
# A <- matrix(c(c(0.9, 0.05,0.05), c(0.05,0.9,0.05), c(0.05, 0.05, 0.9)),3, byrow=T)
A <- matrix(c(c(.8,.1,.1), c(.1,.8,.1), c(.1, .1, .8)),3, byrow=T)

# simulate observations

# generate and plot 1st point 
#z[1,] <- t(rmultinom(1, size=1, prob = c(0.33, 0.33, 0.33)))
z[1,] <- t(rmultinom(1, size=1, prob = c(0.2, 0.6, 0.2)))
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