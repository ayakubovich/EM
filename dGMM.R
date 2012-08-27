#density for Gaussian Mixture Model (GMM) with means mu[k,] k=1...K, mixing proportions p=p1..pk and common covariance matrix sigma
dGMM <- function(x, p, mu, sigma){ 
  d<-0
  for (j in 1:nrow(mu))
    d<-d+p[j]*dmvnorm(x,mu[j,], sigma)
  return(d)
}