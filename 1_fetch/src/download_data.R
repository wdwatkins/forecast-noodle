download_mesonet_data <- function(target_name, nws_site, dateTime_str) {
  
  # Some dummy stuff for now
  dateTime <- as.POSIXct(dateTime_str, format = "%Y%m%d_%H")
  meso_date <- format(dateTime, "%Y%m%d")
  meso_time <- format(dateTime, "%H%M")
  meso_data <- sprintf("NWS Site %s at %s : %s", nws_site, meso_date, meso_time)
  
  saveRDS(meso_data, file = target_name)
  
}

download_nwis_data <- function(ind_file, site, dates) {
  
  # Download the data using dataRetrieval
  nwis_data <- readNWISdata(
      service = "iv",
      siteNumber = site,
      parameterCd = c("00065"),
      startDate = as.Date(dates[["start"]]),
      endDate = as.Date(dates[["end"]])) %>% 
    renameNWISColumns()
  
  # Write the data file and the indicator file
  data_file <- scipiper::as_data_file(ind_file)
  saveRDS(nwis_data, data_file)
  sc_indicate(ind_file) # just until s3_put is added
}
