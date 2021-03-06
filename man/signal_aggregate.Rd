% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/signal_aggregate.R
\name{signal_aggregate}
\alias{signal_aggregate}
\title{Aggregate a time series}
\usage{
signal_aggregate(data, n = 2)
}
\arguments{
\item{data}{\code{Numeric} vector or list of vectors, data set to be 
processed.}

\item{n}{\code{Numeric} scalar, number of samples to be aggregated to one
new data value. Must be an integer value greater than 1. Default is 
\code{2}.}
}
\value{
\code{Numeric} vector or list of vectors, aggregated data.
}
\description{
The time series \code{x} is aggregated by an integer factor \code{n}.
}
\examples{

## load example data set
data(rockfall, envir = environment())

## aggregate signal by factor 4 (i.e., dt goes from 1/200 to 1/50)
rockfall_agg <- signal_aggregate(data = rockfall, n = 4)

## create example data set
s <- 1:10
  
## aggregate x by factor 2
s_agg_2 <- signal_aggregate(data = s,
                            n = 2)
                              
## aggregate x by factor 3
s_agg_3 <- signal_aggregate(data = s, 
                            n = 3)
                              
## plot results
plot(x = s,
     y = rep(x = 1, times = length(s)),
     ylim = c(1, 3))
     
points(x = s_agg_2, 
       y = rep(x = 2, times = length(s_agg_2)), 
       col = 2)

points(x = s_agg_3, 
       y = rep(x = 3, times = length(s_agg_3)), 
       col = 3)
       
abline(v = s_agg_2,
       col = 2)

abline(v = s_agg_3, 
       col = 3)
       
## create signal matrix
X <- rbind(1:100, 1001:1100, 10001:10100)

## aggregate signal matrix by factor 4
X_agg <- signal_aggregate(data = X, 
n = 4)

}
\author{
Michael Dietze
}
\keyword{eseis}
