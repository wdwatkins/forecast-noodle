download_mesonet_data <- function(target_name, nws_site, dateTime_str) {
  
  # Some dummy stuff for now
  dateTime <- as.POSIXct(dateTime_str, format = "%Y%m%d_%H")
  meso_date <- format(dateTime, "%Y%m%d")
  meso_time <- format(dateTime, "%H%M")
  meso_data <- sprintf("NWS Site %s at %s : %s", nws_site, meso_date, meso_time)
  
  saveRDS(meso_data, file = target_name)
  
}
