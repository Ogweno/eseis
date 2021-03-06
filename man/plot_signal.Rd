% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_signal.R
\name{plot_signal}
\alias{plot_signal}
\title{Plot a seismic signal}
\usage{
plot_signal(data, time, n = 10000, ...)
}
\arguments{
\item{data}{\code{Numeric} vector to plot.}

\item{time}{\code{POSIXct} vector, corresponding time vector.}

\item{n}{\code{Numeric} value, number of values to which the dataset 
is reduced. Default is \code{10000}.}

\item{\dots}{Further arguments passed to the plot function.}
}
\value{
A line plot.
}
\description{
This function plots a line graph of a seismic signal. To avoid long plot 
times the signal is reduced to a given number of points.
}
\examples{

## load example data set
data(rockfall)

## plot data set straightforward
plot_signal(data = rockfall, time = t)

## plot data set with lower resolution
plot_signal(data = rockfall, time = t, n = 100)

}
\author{
Michael Dietze
}
\keyword{eseis}
