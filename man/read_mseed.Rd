% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_mseed.R
\name{read_mseed}
\alias{read_mseed}
\title{Read sac-files.}
\usage{
read_mseed(file, append = TRUE, signal = TRUE, time = TRUE, meta = TRUE,
  header = TRUE)
}
\arguments{
\item{file}{\code{Character} vector, input file name(s), with extension. 
Wildcards may be used (see details and examples).}

\item{append}{\code{Logical} scalar, option append single files to one
continuous file, keeping only the hedaer information of the first file.}

\item{signal}{\code{Logical} scalar, option to import the signal vector, 
default is \code{TRUE}.}

\item{time}{\code{Logical} scalar, option to create the time vector. The 
timezone is automatically set to \code{"UTC"}, default is \code{TRUE}.}

\item{meta}{\code{Logical} scalar, option to append the meta data part, 
default is \code{TRUE}.}

\item{header}{\code{Logical} scalar, option to append the header part, 
default is \code{TRUE}.

The function reads one or more mseed-files. If \code{append = TRUE}, all
files will be appended to the first one in the order as they are provided. 
In the append-case the function returns a list of length 4 with the elements 
\code{signal}, \code{time}, \code{meta} and \code{header}. If 
\code{append = FALSE} and nmore than one file is provided, the function
returns a list of the length of the input files, each containing the above
elements. \cr\cr The mseed data format is read using the function 
\code{readMiniseedFile} from the package \code{IRISSeismic}.}
}
\value{
\code{List} object.
}
\description{
This function reads sac-files.
}
\examples{

## Not run - uncomment to run
## read mseed file with default options
# x <- read_mseed(file = "input.miniseed")

## read mseed file, only signal trace
# x <- read_mseed(file = "input.miniseed", 
#                 time = FALSE, 
#                 meta = FALSE, 
#                 header = FALSE)
                
## read more than one mseed files and append traces
# x <- read_mseed(file = c("input_1.miniseed", "input_2.miniseed"))

}
\author{
Michael Dietze
}
