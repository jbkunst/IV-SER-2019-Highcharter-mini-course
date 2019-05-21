# Pacotes -----------------------------------------------------------------
library(highcharter)
library(tidyverse)
library(gapminder)


# MIRA!!! -----------------------------------------------------------------
options(highcharter.theme = hc_theme_ggplot2())


# Documentação ------------------------------------------------------------
# 
# https://api.highcharts.com/highcharts/tooltip
# 

# Exemplo motivacional ----------------------------------------------------
# 
# - http://jkunst.com/blog/posts/2017-03-03-giving-a-thematic-touch-to-your-interactive-chart/
# - http://jkunst.com/blog/posts/2016-03-08-pokemon-vizem-all/

# Dados -------------------------------------------------------------------
data(citytemp)

citytemp_long <- citytemp %>% 
  gather(city, temp, -month) %>% 
  mutate(month = factor(month, month.abb))

hc <- hchart(citytemp_long, "line", hcaes(month, temp, group = city)) %>% 
  hc_title(text = "Titulo") %>% 
  hc_subtitle(text = "interesante subtitulo")

hc


# Comenzando --------------------------------------------------------------
hc %>% 
  hc_tooltip(
    crosshairs = TRUE,
    backgroundColor = "lightgray",
    shared = TRUE,
    borderWidth = 5,
    valueSuffix = "º celcius",
    valuePrefix = "$"
    )

# https://api.highcharts.com/highcharts/tooltip.crosshairs
# https://api.highcharts.com/highcharts/tooltip.backgroundColor
# https://api.highcharts.com/highcharts/tooltip.shared
# https://api.highcharts.com/highcharts/tooltip.borderWidth
# https://api.highcharts.com/highcharts/tooltip.valuePrefix
# https://api.highcharts.com/highcharts/tooltip.valueSuffix

hc %>% 
  hc_tooltip(
    split = TRUE,
    style = list(fontSize = "1.3em")
  )

# https://api.highcharts.com/highcharts/tooltip.split

hc %>% 
  hc_tooltip(
    table = TRUE,
    sort = TRUE
    )


# Medium ------------------------------------------------------------------
data("gapminder")

gapminder2 <- gapminder %>% 
  filter(year == max(year))


hc2 <- hchart(gapminder2, "point", hcaes(gdpPercap, lifeExp, z = pop, group = continent))
hc2


# Some tweaks
hc2 <- hc2 %>% 
  hc_xAxis(type = "logarithmic") %>% 
  hc_plotOptions(series = list(minSize = 3, maxSize = 50))
  
hc2 # ???!!!!???!!!!

# Now see ?tooltip_table 
# Access the data with: "{point.variable}", exemplo: "{point.country}"

?tooltip_table

glimpse(gapminder2)


x <- c("Country:", "Expentacion", "Population", "gdp Percap")
y <- c("{point.country}", "{point.lifeExp}", "{point.pop}","{point.gdpPercap}")

tt <- tooltip_table(x, y)

hc2 %>% 
  hc_tooltip(
    pointFormat = tt,
    useHTML = TRUE,
    crosshairs = TRUE
  )


# Advanced ----------------------------------------------------------------
# 
# Exemplo motivacional
# 
# - http://jkunst.com/blog/posts/2019-02-04-using-tooltips-in-unexpected-ways/
# 
gapminder3 <- gapminder %>%
  select(country, year, pop) %>% 
  nest(-country) %>%
  mutate(
    data = map(data, mutate, x = year, y = pop),
    data = map(data, list_parse)
    ) %>%
  rename(ttdata = data)

gptot <- left_join(gapminder2, gapminder3, by = "country")

hc <- hchart(
  gptot,
  "point",
  hcaes(
    lifeExp,
    gdpPercap,
    name = country,
    size = pop,
    group = continent
  )
) %>%
  hc_yAxis(type = "logarithmic")

hc

# https://jsfiddle.net/gh/get/library/pure/highcharts/highcharts/tree/master/samples/highcharts/yaxis/labels-format/

hc %>%
  hc_tooltip(
    useHTML = TRUE,
    pointFormatter = tooltip_chart(accesor = "ttdata")
    ) %>% 
  hc_plotOptions(series = list(minSize = 3, maxSize = 50)) %>% 
  hc_yAxis(labels = list(format = "${value}"))


