download_mesonet_data <- function(target_name, nws_site, dateTime_str) {
  
  # Some dummy stuff for now
  dateTime <- as.POSIXct(dateTime_str, format = "%Y%m%d_%H")
  meso_date <- format(dateTime, "%Y-%m-%d")
  meso_time <- format(dateTime, "%H%M")
  message(sprintf("NWS Site %s at %s : %s", nws_site, meso_date, meso_time))
  #note that a double percent is required before the date here in order to escape the percent sign 
  #Will get a "not enough arguments" error otherwise
  url <- sprintf("https://mesonet.agron.iastate.edu/plotting/auto/plot/160/station:%s::dt:%s%%20%s::var:primary::dpi:100.csv",
                 nws_site, meso_date, meso_time)
  
  meso_data <- read_csv(url, col_types = list(issued = col_character()))
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
