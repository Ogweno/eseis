#' Aggregate a time series
#' 
#' The time series \code{x} is aggregated by an integer factor \code{n}.
#' 
#' @param data \code{Numeric} vector or list of vectors, data set to be 
#' processed.
#' 
#' @param n \code{Numeric} scalar, number of samples to be aggregated to one
#' new data value. Must be an integer value greater than 1. Default is 
#' \code{2}.
#' 
#' @return \code{Numeric} vector or list of vectors, aggregated data.
#' @author Michael Dietze
#' @keywords eseis
#' @examples
#' 
#' ## load example data set
#' data(rockfall, envir = environment())
#' 
#' ## aggregate signal by factor 4 (i.e., dt goes from 1/200 to 1/50)
#' rockfall_agg <- signal_aggregate(data = rockfall, n = 4)
#' 
#' ## create example data set
#' s <- 1:10
#'   
#' ## aggregate x by factor 2
#' s_agg_2 <- signal_aggregate(data = s,
#'                             n = 2)
#'                               
#' ## aggregate x by factor 3
#' s_agg_3 <- signal_aggregate(data = s, 
#'                             n = 3)
#'                               
#' ## plot results
#' plot(x = s,
#'      y = rep(x = 1, times = length(s)),
#'      ylim = c(1, 3))
#'      
#' points(x = s_agg_2, 
#'        y = rep(x = 2, times = length(s_agg_2)), 
#'        col = 2)
#'
#' points(x = s_agg_3, 
#'        y = rep(x = 3, times = length(s_agg_3)), 
#'        col = 3)
#'        
#' abline(v = s_agg_2,
#'        col = 2)
#'
#' abline(v = s_agg_3, 
#'        col = 3)
#'        
#' ## create signal matrix
#' X <- rbind(1:100, 1001:1100, 10001:10100)
#' 
#' ## aggregate signal matrix by factor 4
#' X_agg <- signal_aggregate(data = X, 
#' n = 4)
#' 
#' @export signal_aggregate
signal_aggregate <- function(
  data,
  n = 2
) {
  
  ## check data structure
  if(class(data) == "list") {
    
    ## apply function to list
    data_out <- lapply(X = data, 
                       FUN = eseis::signal_aggregate, 
                       n = n)
    
    ## return output
    return(data_out)
  } else {
    
    ## check aggregation factor
    if(signif(n) != n) {
      
      n <- round(x = n, 
                 digits = 0)
      warning("Aggregation factor rounded to integer value!")
    }
    
    if(n < 1) {
      
      n <- 1
      warning("Aggregation factor smaller than 1, set to 1 automatically!")
    }
    
    ## check/set data structure
    if(is.matrix(data) == FALSE) {
      data <- rbind(data)
    }
    
    ## aggregate data
    if(n %% 2 == 0) {
      
      ## resample input data set
      data_agg <- data[,seq(from = 1, 
                            to = ncol(data), 
                            by = n)]
      
      ## check/restore data structure
      if(is.matrix(data_agg) == FALSE) {
        data_agg <- t(as.matrix(data_agg))
      }
      
      ## calculate mean input data difference
      d_data_1 <- mean(x = apply(X = data, 
                                 MARGIN = 1, 
                                 FUN = diff), 
                       na.rm = TRUE)
      
      ## calculate mean aggregated data difference
      d_data_2 <- mean(x = apply(X = data_agg, 
                                 MARGIN = 1, 
                                 FUN = diff), 
                       na.rm = TRUE)
      
      ## shift aggregated values to center of original values
      data_agg <- data_agg - d_data_1 / 2 + d_data_2 / 2
      
    } else {
      
      data_agg <- data[,seq(from = ceiling(n / 2), 
                            to = ncol(data), 
                            by = n)]
    }
    
    ## make output consistent
    if(nrow(data) == 1) {
      
      data_agg <- as.numeric(data_agg)
    }
    
    ## return output
    return(data_agg) 
  }
}