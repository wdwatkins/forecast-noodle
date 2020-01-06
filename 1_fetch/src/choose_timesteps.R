choose_timesteps <- function(dates, timestep) {
  # Timestep is in hours, convert to number of seconds
  timestep_min <- timestep * 3600
  timesteps <- seq(as.POSIXct(dates$start, tz = "UTC"), as.POSIXct(dates$end, tz = "UTC"), by = timestep_min)
  return(timesteps)
}
