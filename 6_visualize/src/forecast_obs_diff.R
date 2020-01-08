mesonet_files <- list.files(path="1_fetch/out/", 
                            pattern = "mesonet_data_(.*).rds$",
                            full.names = TRUE)
mesonet_all <- NULL
for(file in mesonet_files) {
  one_file <- readRDS(file)
  mesonet_all <- bind_rows(mesonet_all, one_file)
}
mesonet_distinct <- distinct(mesonet_all) %>% 
  mutate(issued = lubridate::round_date(as.POSIXct(issued, tz = "UTC"), unit = '15 minutes'))

obs <- readRDS('1_fetch/out/nwis_data.rds')

joined <- inner_join(obs, mesonet_distinct, by = c("dateTime" = "valid")) %>% 
  mutate(forecast_range = dateTime - issued,
         forecast_range_round = 2*(forecast_range/2))

#seems issued datetimes are inconsistent, so forecasted points are odd intervals out :(
#don't line up on nice 6/12/18/24 hour etc intervals
#check out distribution here
nsum <- joined %>% group_by(forecast_range_round) %>% summarize(n=n())

forecast_ranges <- c(4,16,28,40,64,88)
layout(matrix(data = 1:6, nrow = 3, ncol = 2, byrow=TRUE))
for(range in forecast_ranges) {
  df <- filter(joined, forecast_range_round == range)
  plot(df$dateTime, df$GH_Inst, type = 'n', ylab = "Stage", xlab = "Date")
  lines(df$dateTime, df$GH_Inst)
  lines(df$dateTime, df$primary_value)
  polygon(c(df$dateTime, rev(df$dateTime)), c(df$GH_Inst, rev(df$primary_value)),
          col = "grey30", border = NA)
  par(lwd=2)
  lines(df$dateTime, df$GH_Inst, col = "red")
  title(sprintf("Forecast range: %s hours", range))
}

