#' Fix corrupt miniseed files
#' 
#' This function is a wrapper for the library dataselect from IRIS. It 
#' reads a corrupt mseed file and saves it in fixed state. Therefore, the 
#' function requires dataselect being installed (see details). Like all the 
#' other aux-function of the package, this function is at preliminary stage
#' and mainly used for internal purpose.
#' 
#' The library dataselect can be downloaded at https://github.com/iris-edu/dataselect
#' and requires compilation (see README file in dataselect directory). The 
#' function goes back to an email discussion with Gillian Sharer (IRIS team),
#' many thanks for pointing me at this option to process corrupt mseed files.
#' 
#' @param file \code{Character} vector, file(s) to process. 
#' 
#' @param input_dir \code{Character} value, path to input directory, i.e., 
#' the directory where the files to process are located.
#' 
#' @param output_dir \code{Character} value, path to output directory, i.e., 
#' the directory where the processed files are written to. This must be 
#' different from \code{input_dir}.
#' 
#' @param software \code{Charcter} value, path to the dataselect library, 
#' required unless the path to the library is made gobally visible.
#' 
#' @return a set of mseed files written to disk.
#' 
#' @author Michael Dietze
#' 
#' @keywords eseis
#' 
#' @examples
#' 
#' ## uncomment to use
#' # aux_fixmseed(file = list.files(path = "~/data/mseed", 
#' #                                pattern = "miniseed"), 
#' #                     input_dir = "~/data/mseed",
#' #                     output_dir = "~/data/mseed/out",
#' #                     software = "~/software/dataselect-3.17")
#' 
#' @export aux_fixmseed
#' 
aux_fixmseed <- function(file, input_dir, output_dir, software) {
  
  ## check/set parameters
  if(missing(software) == TRUE) {
    
    software <- ""
  }
  
  invisible(lapply(X = file, FUN = function(
    file, 
    input_dir, 
    output_dir, 
    software) {
    
    x <- try(system(command = paste(software,
                                    "/dataselect -o ",
                                    output_dir, "/", 
                                    file,
                                    " ",
                                    input_dir, "/", file, sep = "")), 
             silent = TRUE)
    
    if(class(x) == "try-error") {
      
      warning(paste("File", file, "not fixed!"))
    }
  },
  input_dir = input_dir,
  output_dir = output_dir,
  software = software))
}