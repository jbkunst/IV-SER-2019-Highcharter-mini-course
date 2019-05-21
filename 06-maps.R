# Pacotes -----------------------------------------------------------------
library(highcharter)
library(tidyverse)
library(readxl)

# Exemplo motivacional ----------------------------------------------------
# 
# - http://jkunst.com/blog/posts/2017-01-05-thematic-interactive-map/
# - http://jkunst.com/blog/posts/2016-12-15-interactive-and-styled-middle-earth-map/
# 

# Documentação ------------------------------------------------------------
# 
# http://jkunst.com/highcharter/highmaps.html
# 
# https://code.highcharts.com/mapdata/
# 

# example 1 ---------------------------------------------------------------
hcmap("countries/br/br-all")

hcmap("countries/br/br-all", showInLegend = FALSE)


# example 2 ---------------------------------------------------------------
example_data <- get_data_from_map(download_map_data("countries/br/br-all"))

example_data 

example_data <- example_data %>% 
  select(`hc-a2`, `woe-name`, name)

example_data

brdata <- read_xlsx("data/BasesEstados.xlsx") 

brdata 

brdata <- brdata %>% 
  select(S, Taxa_analfabetismo)
 
brdata <- left_join(brdata, example_data, by = c("S" = "hc-a2"))
brdata

hcmap("countries/br/br-all", data = brdata, value = "Taxa_analfabetismo", name = "Taxa Analfabetismo")

hcmap(
  "countries/br/br-all",
  data = brdata,
  value = "Taxa_analfabetismo",
  name = "Taxa Analfabetismo",
  dataLabels = list(enabled = TRUE, format = '{point.name}')
  )

brmap <- hcmap(
  "countries/br/br-all",
  data = brdata,
  value = "Taxa_analfabetismo",
  name = "Taxa Analfabetismo",
  dataLabels = list(enabled = TRUE, format = '{point.name}'),
  borderColor = "transparent"
)

brmap

brmap %>% 
  hc_colorAxis(minColor = "white", maxColor = "red")


brmap <- brmap %>%
  hc_colorAxis(
    dataClasses = color_classes(c(0, 5, 10, 15, 30, 60))
    ) %>% 
  hc_legend(
    layout = "vertical", 
    align = "right",
    floating = TRUE,
    valueDecimals = 0,
    valueSuffix = "%"
    ) 

brmap



# example 3 ---------------------------------------------------------------
# http://openflights.org/data.html
airports <- read_csv("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat", col_names = FALSE)
airports <- airports %>%
  filter(X4 == "Brazil") %>% 
  select(nombre = X2, lon = X8, lat = X7)

airports

hcmap("countries/br/br-all", showInLegend = FALSE) %>% 
  hc_add_series(
    data = airports, 
    type = "mappoint",
    name = "Airports",
    tooltip = list(pointFormat = "{point.nombre}")
    ) 

brmap2 <- brmap %>% 
  hc_add_series(
    data = airports,
    type = "mappoint",
    color = "skyblue",
    name = "Airports",
    tooltip = list(pointFormat = "{point.nombre}")
  )

brmap2


# Zoom?
brmap2 %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_mapNavigation(
    enabled = TRUE,
    enableMouseWheelZoom = TRUE
    )


# Exercícios --------------------------------------------------------------
# 
# RECAP!!!
# 
# Do messmo para America del Sur:
# 
# 1. See Ameria del Sur "demo" in https://code.highcharts.com/mapdata/ ("custom/south-america")
# 2. Agregue datos ficticios
# 3. Agregue titulo, subtitulo, legenda
# 4. Agregue nueva paleta de colores minColor, maxColor 
# 5. Add a "hc_theme_db" theme
# 