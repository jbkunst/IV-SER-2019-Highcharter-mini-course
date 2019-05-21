# Pacotes -----------------------------------------------------------------
library(highcharter)



# Documentação ------------------------------------------------------------
# 
# http://jkunst.com/highcharter/hchart.html
# 

# Contexto ----------------------------------------------------------------
# 
# plot is a generic (magical) funcion.
# 
# What it means "generic"? A generic function will do 
# an action depending of the "argument" (objetc class)
# 
# For example:
# 

# Densidades
x <- rnorm(1000)

x

d <- density(x)

plot(d)

# Time series
data(AirPassengers)
plot(AirPassengers)

# Forecast
library(forecast)
fit <- forecast(AirPassengers)
plot(fit)

# 
# UMA (1!!) função
# 

# hchart ------------------------------------------------------------------
# 
# hchart is a generic function too! :)
# 
# Densidades
hchart(d)


# time series
hchart(AirPassengers)

# forecast
hchart(fit)

# Numerics
x <- rgamma(3000, 2, 4)
x
hchart(x)

# Character
data(mpg, package = "ggplot2")
hchart(mpg$manufacturer)

# Factor
data(diamonds, package = "ggplot2")
hchart(diamonds$cut)

# Matrix & correlations
data(volcano)
hchart(volcano)

# Exercícios --------------------------------------------------------------
# 
# 1. Plotar os dados "USAccDeaths".
#    (semelhante ao exemplo de Airpassengers)
# 

# 
# 2. Obter uma matriz de correlações dos dados mtcars
#    usando a função "cor", então use a função hchart
# 
