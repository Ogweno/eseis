#' Calculate stal-lta-ratio.
#' 
#' The function calculates the ratio of the short-term-average and 
#' long-term-average of the input signal.
#' 
#' @param data \code{Numeric} vector or list, input signal envelope vector(s).
#' 
#' @param time \code{POSIXct} vector, time vector of the signal(s). If not 
#' provided, a synthetic time vector will be created.
#' 
#' @param dt \code{Numeric} scalar, sampling period. If omitted, either 
#' estimated from \code{time} or set to 0.01 s (i.e., f = 100 Hz). 
#' 
#' @param sta \code{Numeric} scalar, number of samples for short-term window.
#' 
#' @param lta \code{Numeric} scalar, number of samples for long-term window.
#' 
#' @param freeze \code{Logical} scalar, option to freeze lta value at start of 
#' an event. Useful to avoid self-adjustment of lta for long-duration events. 
#' 
#' @param on \code{Numeric} scalar, threshold value for event onset.
#' 
#' @param off \code{Numeric} scalar, threshold value for event end.
#' 
#' @return \code{data frame}, detected events (ID, start time, duration in 
#' seconds).
#' @author Michael Dietze
#' @keywords eseis
#' @examples
#' 
#' ## load example data
#' data(rockfall)
#' 
#' ## filter signal
#' sf <- signal_filter(data = rockfall, 
#'                     dt = 1/200, 
#'                     f = c(1, 90), 
#'                     p = 0.05)
#'                     
#' ## calculate signal envelope
#' e <- signal_envelope(data = sf)
#' 
#' ## pick earthquake and rockfall event
#' signal_stalta(data = e, 
#'               time = t, 
#'               sta = 100, 
#'               lta = 18000, 
#'               freeze = TRUE, 
#'               on = 5, 
#'               off = 3)
#'               
#'                      
#' @export signal_stalta
signal_stalta <- function(
  data,
  time,
  dt,
  sta,
  lta,
  freeze = FALSE,
  on,
  off
) {
  
  ## missing dt value
  if(missing(dt) == TRUE) {
    
    if(missing(time) == TRUE) {
      
      dt = 0.01
      warning("No dt provided. Set to 0.01 s by default!")
    } else {
      
      if(length(time) > 1000) {
        
        time_dt <- time[1:1000]
      } else {
        
        time_dt <- time
      }
      
      dt_estimate <- mean(x = diff(x = as.numeric(time)), 
                          na.rm = TRUE)
      print(paste("dt estimated from time vector (", 
                  signif(x = dt_estimate),
                  " s)",
                  sep = ""))
      
      dt <- dt_estimate
    }
  }
  
  ## missing time vector
  if(missing(time) == TRUE) {
    
    time <- seq(from = as.POSIXct(x = strptime(x = "0000-01-01 00:00:00",
                                               format = "%Y-%m-%d %H:%M:%S", 
                                               tz = "UTC"), tz = "UTC"),
                by = dt,
                length.out = length(data))
    
    print("No or non-POSIXct time data provided. Default data generated!")
  }

  ## check data structure
  if(class(data) == "list") {
    
    ## apply function to list
    data_out <- lapply(X = data, 
                       FUN = eseis::signal_stalta,
                       time = time,
                       dt = dt,
                       sta = sta,
                       lta = lta,
                       freeze = freeze,
                       on = on,
                       off = off)
    
    ## return output
    return(data_out)
  } else {

    ## calculate sta vector
    data_sta <- caTools::runmean(x = data, 
                                 k = sta, 
                                 alg = "fast", 
                                 endrule = "NA",
                                 align = "right")
    
    ## calculate lta vector
    data_lta <- caTools::runmean(x = data, 
                                 k = lta, 
                                 alg = "fast", 
                                 endrule = "NA",
                                 align = "right")
    
    ## create output data set
    event <- rep(x = 0, 
                 times = length(data))
    
    if(freeze == TRUE) {
      
      event <- .stalta_event_freeze(event_length = length(event),
                                    data_sta = data_sta,
                                    data_lta = data_lta,
                                    on = on,
                                    off = off)
    } else {
      
      ## calculate ratio
      ratio <- data_sta / data_lta
      ratio[is.na(ratio)] <- 0
      
      ## assign event trigger
      event <- .stalta_event_nofreeze(event_length = length(event),
                                      ratio = ratio,
                                      on = on,
                                      off = off)
    }

    ## calculate event state switches
    event_diff <- diff(x = event)

    ## asign on and off states
    event_on <- time[event_diff == 1]
    event_off <- time[event_diff == -1]

    ## calculate event duration
    event_duration <- as.numeric(difftime(time1 = event_off, 
                                          time2 = event_on, 
                                          units = "sec"))
    
    ## create ID vector
    ID <- seq(from = 1, 
              along.with = event_duration)
    
    ## build output data set
    if(length(ID) > 0) {
      
      data_out <- data.frame(ID = ID,
                             start = event_on,
                             duration = event_duration)
      
    } else {
      
      data_out <- data.frame(ID = NA,
                             start = NA,
                             duration = NA)[-1,]
    }

    ## return output
    return(data_out)
  }
}