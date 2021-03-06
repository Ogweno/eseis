#' Write seismic traces as sac-file to disk.
#'
#' This function converts seismic traces to sac-files and writes them to disk.
#' 
#' For description of the sac file format see
#' https://ds.iris.edu/files/sac-manual/manual/file_format.html. Currently the 
#' following parameters are not supported when writing the sac file: 
#' LAT, LON, ELEVATION, NETWORK.
#'
#' @param data \code{Numeric} vector, seismic trace to be written.
#' 
#' @param file \code{Character} scalar, filename with extension.
#' 
#' @param time \code{POSIXct} vector, time vector corresponding to the 
#' seismic trace. Alternatively, the start time stamp can be provided as
#' \code{POSIXct} value and a value for \code{dt} must be given.
#' 
#' @param component \code{Character} scalar, component ID, optional.
#' 
#' @param unit \code{Character} scalar, unit of the signal, optional. One out
#' of \code{"unknown"}, \code{"displacement"}, \code{"velocity"}, 
#' \code{"volts"}, \code{"acceleration"}. Default is \code{"unknown"}.
#' 
#' @param station \code{Character} scalar, station ID, optinal.
#' 
#' @param location \code{Character} vector of length four, station location 
#' data (latitude, longitude, elevation, depth), optional.
#' 
#' @param network \code{Character} scalar, network ID, optional.
#' 
#' @param dt \code{Numeric} scalar, sampling period. Only needed if no time
#' vector is provided.
#' 
#' @param parameters \code{Data frame} sac parameter list, as obtained from
#' \code{list_sacparameters}. Allows user-specific modifications. If this 
#' data frame is provided, it overrides all other arguments. 
#' 
#' @param biglong \code{Logical} scalar, biglong option, default is 
#' \code{FALSE}
#' 
#' @return A binary file written to disk.
#' @author Michael Dietze
#' @examples
#'
#' ## No examples ready, yet.
#'
#' @export write_sac
write_sac <- function(
  data,
  file,
  time,
  component,
  unit,
  station,
  location,
  network,
  dt,
  parameters,
  biglong = FALSE
) {

  ## check/set biglong-dependent parameters
  if(biglong == TRUE) {
    ilong <- 8
    ifloat <- 4
  } else {
    ilong <- 4
    ifloat <- 4
  }
  
  ## check/set station
  if(missing(station) == TRUE) {
    
    print("Station name missing! Value station set to NULL")
    station <- "NULL"
  }
  
  ## check/set network
  if(missing(network) == TRUE) {
    
    print("Network name missing! Value network set to NULL")
    network <- "NULL"
  }
  
  ## check/set component
  if(missing(component) == TRUE) {
    
    print("Component name missing! Value component set to p0")
    component <- "p0"
  }
  
  ## check/set unit
  if(missing(unit) == TRUE) {
    
    print("Unit missing! Value unit set to 1 ('unknown')")
    unit <- "unknown"
  }
  
  ## reassign unit ID
  if(unit == "unknown") {unit <- 1}
  if(unit == "displacement") {unit <- 2}
  if(unit == "velocity") {unit <- 3}
  if(unit == "volts") {unit <- 4}
  if(unit == "acceleration") {unit <- 5}
  
  ## check/set location
  if(missing(location) == TRUE) {
    
    print("Location information missing! Values set to -12345")
    location <- rep(x = -12345, times = 4)
  }
  
  ## check/set time vector
  if(missing(time) == TRUE) {
    
    stop("No time information provided. Cannot generate sac-file.")
  } else if(length(time) == 1) {
    
    if(missing(dt) == TRUE) {
      stop("No sampling period (dt) provided. Cannot generate sac-file.")
    }
    
    time <- seq(from = time, by = dt, length.out = length(data))
  }
  
  ## check/set dt
  if(missing(dt) == TRUE) {
    dt <- as.numeric(mean(diff(time)))
  }
  
  ## round dt
  dt <- signif(x = dt, digits = 10)
  
  ## get first time entry
  start <- time[1]
  
  ## create time data
  yr <- as.numeric(format(start, "%Y"))
  jd <- as.numeric(as.POSIXlt(start)$yday + 1)
  mo <- as.numeric(format(start, "%m"))
  dom <- as.numeric(format(start, "%d"))
  hr <- as.numeric(format(start, "%H"))
  mi <- as.numeric(format(start, "%M"))
  sec   <- as.numeric(format(start, "%S"))
  msec <- as.numeric(format(start, "%OS")) - sec
  t1 <- 0
  t2 <- length(data) * dt
  off <- 0
  
  ## padd values with zeros
  jd_3 <- ifelse(nchar(jd) < 2, paste("00", jd, sep = ""), jd)
  jd_3 <- ifelse(nchar(jd_3) < 3, paste("0", jd_3, sep = ""), jd_3)
  
  hr_2 <- ifelse(nchar(hr) < 2, paste("0", hr, sep = ""), hr)
  mi_2 <- ifelse(nchar(mi) < 2, paste("0", mi, sep = ""), mi)
  sec_2 <- ifelse(nchar(sec) < 2, paste("0", sec, sep = ""), sec)
  
  ## check/set file names
  if(missing(file) == TRUE) {
    
    print("No file name provided. File name will be generated automatically.")
    
    file <- paste(station, "_",
                  yr, "_",
                  jd_3, "_",
                  hr_2, "_",
                  mi_2, "_",
                  sec_2, "_", 
                  component,
                  ".sac", sep = "")
  }
  
  if(missing(parameters) == TRUE) {
    
    ## get default sac parameter definition
    sac_parameters <- list_sacparameters()
    class(sac_parameters$value) <- "character"
    
    ## update sac parameters
    sac_parameters$value[1] <- as.character(dt)
    
    sac_parameters$value[2] <-  min(data, na.rm = TRUE)
    
    sac_parameters$value[3] <-  max(data, na.rm = TRUE)
    
    sac_parameters$value[4] <-  1
    
    sac_parameters$value[5] <-  "-12345"

    sac_parameters$value[6] <- t1
    
    sac_parameters$value[7] <- t2
    
    sac_parameters$value[8:31] <- rep(x = "-12345", times = 24)
    
    sac_parameters$value[32:35] <- location
    
    sac_parameters$value[36] <- "0"
    
    sac_parameters$value[37] <- "0"
    
    sac_parameters$value[38:50] <- rep(x = "-12345", times = 13)
    
    sac_parameters$value[51] <- "0"
    
    sac_parameters$value[52:56] <- rep(x = "-12345", times = 5)
    
    sac_parameters$value[57] <- mean(x = data, na.rm = TRUE)
    
    sac_parameters$value[58] <- "0"
    
    sac_parameters$value[59] <- "0"
    
    sac_parameters$value[60:70] <- rep(x = "-12345", times = 11)
    
    sac_parameters$value[71] <- yr
    
    sac_parameters$value[72] <- jd
    
    sac_parameters$value[73] <- hr
    
    sac_parameters$value[74] <- mi
    
    sac_parameters$value[75] <- sec
    
    sac_parameters$value[76] <- msec
    
    sac_parameters$value[77] <- "6"
    
    sac_parameters$value[78] <- "-12345"
    
    sac_parameters$value[79] <- "-12345"
    
    sac_parameters$value[80] <- length(data)
    
    sac_parameters$value[81:85] <- rep(x = "-12345", times = 5)
    
    sac_parameters$value[86] <- 1
    
    sac_parameters$value[87] <- unit
    
    sac_parameters$value[88] <- 9
    
    sac_parameters$value[89:105] <- rep(x = "-12345", times = 17)
    
    sac_parameters$value[106] <- 1

    sac_parameters$value[107] <- 1

    sac_parameters$value[108] <- 1

    sac_parameters$value[109] <- 0
    
    sac_parameters$value[110] <- "-12345"
    
    sac_parameters$value[111] <- station
    
    sac_parameters$value[112] <- "-12345"
    
    sac_parameters$value[113] <- "XX"
    
    sac_parameters$value[114:129] <- rep(x = "-12345", times = 16)
    
    sac_parameters$value[130] <- component
    
    sac_parameters$value[131] <- network
    
    sac_parameters$value[132] <- "-12345"
    
    sac_parameters$value[133] <- "-12345"
  } else {
    
    sac_parameters <- parameters
  }
  
    ## open binary file
    SAC <- file(description = file, open = "wb")
    
    ## write float part to sac-file
    writeBin(object = as.numeric(sac_parameters$value[1:70]), 
             con = SAC, 
             size = ifloat, 
             endian = .Platform$endian)
    
    ## write long part to sac-file
    writeBin(object = as.integer(sac_parameters$value[71:110]),
             con = SAC, 
             size = ilong, 
             endian = .Platform$endian)
    
    ## write character part to sac-file
    writeChar(object = format(as.character(sac_parameters$value[111]), 
                              width = 8, 
                              justify = "left"), 
              con = SAC, 
              nchars = 8, 
              eos = NULL)
    
    writeChar(object = format(as.character(sac_parameters$value[112]), 
                              width = 16, 
                              justify = "left"), 
              con = SAC, 
              nchars = 16, 
              eos = NULL)
              
    
    for(j in 113:133) {
      writeChar(object = format(as.character(sac_parameters$value[j]), 
                                width = 8, 
                                justify = "left"), 
                con = SAC, 
                nchars = 8, 
                eos = NULL)
    }
    
    ## write signal part to sac-file
    writeBin(object = data, 
             con = SAC, 
             size = ifloat, 
             endian = .Platform$endian)
    
    ## close connection
    close(SAC)
}
  