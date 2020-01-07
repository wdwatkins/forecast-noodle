prep_modeled_lines_fun <- function(mesonet_data_ind, task_dateTime) {
  
  mesonet_data_thisframe <- 
    readRDS(as_data_file(mesonet_data_ind)) %>% 
    # This could probably belong in a 2_process step, but at this point,
    # I don't want to create `2_process.yml` for only 2 little targets.
    select(forecast_id = id,
           forecast_timestamp = issued,
           dateTime = valid,
           # there is a difference between the `primary_value` column and `Stage[ft]`
           # `Stage[ft]` had some NAs when `primary_value` did not
           Stage = primary_value) 
  
  models_to_plot <- unique(mesonet_data_thisframe$forecast_id)
  colors_to_use <- palette(rainbow(length(models_to_plot)))
  
  plot_fun <- function() {
    for(id in 1:length(models_to_plot)) {
      mesonet_data_id <- filter(mesonet_data_thisframe, forecast_id == models_to_plot[id])
      points(x = mesonet_data_id$dateTime,
             y = mesonet_data_id$Stage, 
             col = colors_to_use[id], # temporary color solution for now
             type = 'l', lwd = 1.5)
    }
    
  }
  return(plot_fun)
}
