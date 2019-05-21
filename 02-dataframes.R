# Pacotes -----------------------------------------------------------------
library(highcharter)
library(ggplot2)
library(dplyr)
library(readxl)


# Documentação ------------------------------------------------------------
# 
# https://cran.r-project.org/web/packages/highcharter/vignettes/charting-data-frames.html
# 

# Contexto ----------------------------------------------------------------
# 
# ggplot2
# 
# ggplot uses geom and aesthetics
# 
data(economics_long, package = "ggplot2")

ggplot(economics_long) +
  geom_line(aes(x = date, y = value01, color = variable))

# GEOM / capa

# aestetics 

# see: 


# highcharter -------------------------------------------------------------
# 
# Version I
# 
hchart(economics_long, "line", hcaes(x = date, y = value01, group = variable))

# 
# Version II
# 
highchart() %>% 
  hc_add_series(economics_long, "line", hcaes(x = date, y = value01, group = variable)) %>% 
  hc_xAxis(type = "datetime")

# ?!?! %>%?!! não importa, então vamos falar sobre isso 


# Adicionar mais de um conjunto de dados ----------------------------------
# 
glimpse(mtcars)

mtcars <- arrange(mtcars, mpg, disp)

dados_cyl_4 <- filter(mtcars, cyl == 4)
dados_cyl_6 <- filter(mtcars, cyl == 6)
  
highchart() %>% 
  hc_add_series(dados_cyl_4, "scatter", hcaes(mpg, disp), color = "red", name = "cyl2")

highchart() %>% 
  hc_add_series(dados_cyl_6, "scatter", hcaes(mpg, disp), color = "red", name = "cyl2") %>% 
  hc_add_series(dados_cyl_4, "line", hcaes(mpg, disp), color = "blue", name = "cyl4")

# 
# Mas melhor: group
# 
highchart() %>% 
  hc_add_series(mtcars, "scatter", hcaes(mpg, disp, group = cyl)) 

# 
# ou usando hchart :)
# 
hchart(mtcars, type = "scatter", mapping = hcaes(mpg, disp, group = cyl)) 


# exemplo mais divertido --------------------------------------------------
# 
library(broom)

modlss <- loess(disp ~ mpg, data = mtcars)
fit <- arrange(augment(modlss), mpg)

fit

fit <- fit %>% 
  mutate(
    low_fit = .fitted - 1.96*.se.fit,
    high_fit = .fitted + 1.96*.se.fit
  )

fit


highchart() %>% 
  hc_add_series(mtcars, "scatter", hcaes(mpg, disp, group = cyl)) 

highchart() %>% 
  hc_add_series(mtcars, "scatter", hcaes(mpg, disp, group = cyl)) %>% 
  hc_add_series(fit, "spline", hcaes(x = mpg, y = .fitted), name = "Fit")

highchart() %>% 
  hc_add_series(mtcars, "scatter", hcaes(mpg, disp, group = cyl)) %>% 
  hc_add_series(fit, "spline", hcaes(x = mpg, y = .fitted), name = "Fit") %>% 
  hc_add_series(fit, "arearange", hcaes(x = mpg, low = low_fit, high = high_fit),
                color = hex_to_rgba("gray", 0.01), name = "confidence")


# Outro exemplo mais ------------------------------------------------------
estados <- read_xlsx("data/BasesEstadosSerie.xlsx")
glimpse(estados)

hchart(estados, "line", hcaes(ANO, PIB_Estadual)) 

# ?!?!?!?!?!?!?! 
# Por que acontece isso?!?!?
hchart(estados, "line", hcaes(ANO, Populacao, group = Estado)) 




# Exercícios --------------------------------------------------------------
# 
# 1. Con los siguientes datos:
# 
library(forecast)
library(timetk)
library(ggfortify)
library(stringr)

AirPassengers

fit <- forecast(AirPassengers, h = 12, level = 80)

data <- tk_tbl(AirPassengers) 

dforecast <- fortify(fit, ts.connect = TRUE) %>% 
  rename_all(~ str_to_lower(str_remove_all(.x, " "))) %>% 
  as_tibble() %>% 
  filter(!is.na(pointforecast))

data

dforecast

# 
# Representar graficamente os dados originais e previstos
# 
dforecast <- dforecast %>% 
  # mutate(index = format(index, "%Y-%m")) %>% 
  mutate(index = zoo::as.yearmon(index))

hchart(data, "line", hcaes(x = index, y = value), 
       showInLegend = TRUE, name = "dados origanales") %>% 
  hc_add_series(dforecast, "line", hcaes(x = index, y = pointforecast), 
                showInLegend = TRUE, name = "predichos") %>% 
  hc_add_series(dforecast, "arearange", hcaes(x = index, low = lo80, high = hi80), 
                showInLegend = TRUE, name = "miuto legal")
