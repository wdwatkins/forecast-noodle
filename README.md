# forecast-noodle
Illustrating how river forecasts change through time due to model uncertainty.

## Where is this data from?

Found archived NWS flood forecasts on Iowa State University's website Iowa Environmental Mesonet, specifically at the [River Summary tab here](https://mesonet.agron.iastate.edu/river/?all). We will be downloading data for the Mississippi River at Osceola (NWS site OSGA4), which is just north of Memphis, TN on the Mississippi River. Archived forecast data can be [viewed on a plot here](https://mesonet.agron.iastate.edu/plotting/auto/?q=160&station=OSGA4), but we will be downloading data using the url, `https://mesonet.agron.iastate.edu/plotting/auto/plot/160/station:OSGA4::dt:2020-01-06%201951::var:primary::dpi:100.csv`. We can change the data we download by using the template, `https://mesonet.agron.iastate.edu/plotting/auto/plot/160/station:[NWS Site Code]::dt:[YYYY-MM-DD]%20[HHMM]::var:primary::dpi:100.csv`.
