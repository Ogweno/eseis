% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/signal_spectrum.R
\name{signal_spectrum}
\alias{signal_spectrum}
\title{Calculate the spectrum of a time series}
\usage{
signal_spectrum(data, dt, method = "periodogram", ...)
}
\arguments{
\item{data}{\code{Numeric} vector or list of vectors, data set to be 
processed.}

\item{dt}{\code{Numeric} scalar, sampling period. If omitted, \code{dt} 
is set to 1/200.}

\item{method}{\code{Character} scalar, calculation method. One out of 
\code{"periodogram"} , \code{"autoregressive"} and \code{"multitaper"}, 
default is \code{"periodogram"}.}

\item{\dots}{Additional arguments passed to the function. See 
\code{\link{spec.pgram}}, \code{\link{spec.ar}}, \code{\link{spec.mtm}}.}
}
\value{
\code{Data frame} with spectrum and frequency vector
}
\description{
The spectral density estimate of the time series is calculated using 
different approaches.
}
\examples{

## load example data set
data(rockfall, envir = environment())

## calculate spectrum with standard setup
s <- signal_spectrum(data = rockfall, dt = 1/200)

## plot spectrum
plot(s, type = "l", log = "y")

}
\author{
Michael Dietze
}
\keyword{eseis}
