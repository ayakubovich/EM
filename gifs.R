library(animation)
library(MASS)
set.seed(10)

N <- 100
mu <- matrix(c(0,0, 0,12, 6,6),3, byrow=T) #means of multivariate normal kernels
sigma <- diag(c(1,1)) # common covariance matrix
p <- c(.2, .2, .6)  #mixing proportions

# INITIALIZATION
nstates <- 3
z<-mat.or.vec(N, nstates)
y<-mat.or.vec(N,2)

# generate and plot 1st observation 
z[1,] <- t(rmultinom(1, size=1, prob = p ))
y[1,] <- mvrnorm(1, mu[z[1,]==1], sigma)

plot(y[1,1], y[1,2], xlim=c(-5,12), ylim=c(-5,15), col = which(z[1,]>0) + 1, pch=16, xlab='x', ylab='y', , main='Sampling a Gaussian Mixture Model')  
ani.record(reset = TRUE)

for (i in 2:N){  
  z[i,] <- t(rmultinom(1, size=1, prob = p)) # generate (y,z)
  y[i,] <- mvrnorm(1, mu[z[i,]==1], sigma)  
  points(y[i,1], y[i,2], col=which(z[i,]>0) + 1, pch=16) #plot y
  segments(x0=y[i-1,1], y0=y[i-1,2], x1=y[i,1], y1=y[i,2], new=T) #plot line joining yn, yn-1
  ani.record()  # record the current frame  
}

oopts = ani.options(verbose=FALSE)
saveGIF(ani.replay(), movie.name = "sample-GMM.gif")

### Create GIF of HMM Samples ##
 
A <- matrix(c(c(.8,.1,.1), c(.1,.8,.1), c(.1, .1, .8)),3, byrow=T) # transition matrix

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

plot(y[1,1], y[1,2], xlim=c(-5,10), ylim=c(-5,15), col = which(z[1,]>0) + 1, pch=16, xlab='x', ylab='y', main = 'Sampling a Hidden Markov Model')

ani.record(reset = TRUE)

# generate rest of observations
for (i in 2:N){
  prev_state <- which(z[i-1, ]>0)
  z[i,] <- t(rmultinom(1, size=1, prob = A[prev_state, ])) # generate (y,z)
  y[i,] <- mvrnorm(1, mu[z[i,]==1], sigma)
  points(y[i,1], y[i,2], col=which(z[i,]>0) + 1, pch=16) #plot y
  segments(x0=y[i-1,1], y0=y[i-1,2], x1=y[i,1], y1=y[i,2], new=T) #plot line joining yn, yn-1
  ani.record()  # record the current frame  
}

oopts = ani.options(verbose=FALSE)
saveGIF(ani.replay(), movie.name = "sample-HMM.gif")