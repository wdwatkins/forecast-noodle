prep_observed_line_fun <- function(nwis_data_ind, task_dateTime) {
  
  nwis_data <- readRDS(as_data_file(nwis_data_ind))
  
  nwis_data_thisframe <- nwis_data %>% 
    filter(dateTime <= task_dateTime)
  
  if(nrow(nwis_data_thisframe) > 0) {
    plot_fun <- function() {
      points(x = nwis_data_thisframe$dateTime, 
             y = nwis_data_thisframe$GH_Inst, 
             type = "l", lwd = 4)
    }
  } else {
    plot_fun <- function() {
      return()
    }
  }
  return(plot_fun)
}
