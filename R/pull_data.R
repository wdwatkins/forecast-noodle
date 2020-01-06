library(readr)

nws_site <- "OSGA4"
date_center <- "2019-12-12"

#note that a double percent is required before the date here in order to escape the percent sign 
#Will get a "not enough arguments" error otherwise
url <- sprintf("https://mesonet.agron.iastate.edu/plotting/auto/plot/160/station:%s::dt:%s%%201200::var:primary::dpi:100.csv",
               site, date_center)

meso_data <- read_csv(url)


library(ggplot2)
ggplot(meso_data, aes(x = valid, y = primary_value)) + 
  geom_point(aes(col = issued))
