# Pacotes -----------------------------------------------------------------
library(highcharter)
library(tidyverse)

# Documentação ------------------------------------------------------------
# 
# http://jkunst.com/highcharter/themes.html
# 

# Exemplo motivacional ----------------------------------------------------
# 
# - http://jkunst.com/blog/posts/2019-04-08-when-charts-are-integrated-in-the-web-page/
# - http://jkunst.com/blog/posts/2017-03-03-giving-a-thematic-touch-to-your-interactive-chart/
# 

# Dados -------------------------------------------------------------------
data(citytemp)

citytemp_long <- citytemp %>% 
  gather(city, temp, -month) %>% 
  mutate(month = factor(month, month.abb))

hc <- hchart(citytemp_long, "line", hcaes(month, temp, group = city)) %>% 
  hc_title(text = "Titulo") %>% 
  hc_subtitle(text = "interesante subtitulo")

hc


# Themes ------------------------------------------------------------------
# 
# 1. Crear o escoge un tema, exemplo: hc_theme_ggplot2() 
# 
# 2. Agregar con la funcion hc_add_theme()
# 
hc %>% 
  hc_add_theme(hc_theme_ggplot2())

hc %>% 
  hc_add_theme(hc_theme_flatdark())

# Muitos temas:
help.search("hc_theme_", package = "highcharter") 

# 
# - http://jkunst.com/highcharts-themes-collection/
# 

# customization -----------------------------------------------------------
swdata <- structure(
    list(
      movie = c("A New Hope", "Attack of the Clones", "The Phantom Menace",
        "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back",
        "The Force Awakens"
      ),
      species = c(5, 14, 20, 20, 9, 5, 3),
      planets = c(3, 5, 3, 13, 5, 4, 1),
      characters = c(18, 40, 34, 34, 20, 16, 11),
      vehicles = c(4, 11, 7, 13, 8, 6, 0),
      release = c("1977-05-25", "2002-05-16", "1999-05-19",
        "2005-05-19", "1983-05-25", "1980-05-17", "2015-12-11"
      )
    ),
    .Names = c("movie", "species", "planets", "characters", "vehicles", "release"),
    row.names = c(NA,-7),
    class = c("tbl_df", "tbl", "data.frame")
  )


swdata

swdata <- gather(swdata, key, number, -movie, -release) %>% 
  arrange(release)

hchart(swdata, "line", hcaes(x = movie, y = number, group = key)) %>% 
  hc_chart(
    style = list(
      fontSize = "2em",  
        fontSize = "2em"
      )
    ) %>% 
  hc_colors(
    c("#e5b13a", "#4bd5ee", "#4AA942", "#FAFAFA")
    ) %>% 
  hc_title(
    text = "Diversity in <span style=\"color:#e5b13a\"> STAR WARS</span> movies",
    useHTML = TRUE) %>% 
  hc_tooltip(table = TRUE, sort = TRUE) %>% 
  hc_credits(
    enabled = TRUE,
    text = "Source: SWAPI via rwars package",
    href = "https://swapi.co/") %>% 
  hc_add_theme(
    hc_theme_flatdark(
      chart = list(
        backgroundColor = "transparent",
        divBackgroundImage = "http://www.wired.com/images_blogs/underwire/2013/02/xwing-bg.gif"
      )
    )
  )


# Crear -------------------------------------------------------------------
thm <- hc_theme(
  colors = c('red', 'green', 'blue'),
  chart = list(
    backgroundColor = NULL,
    divBackgroundImage = "http://media3.giphy.com/media/FzxkWdiYp5YFW/giphy.gif"
  ),
  title = list(
    style = list(
      color = '#333333',
      fontFamily = "Oswald"
    )
  ),
  subtitle = list(
    style = list(
      color = '#666666',
      fontFamily = "Shadows Into Light"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = 'Tangerine',
      color = 'black',
      fontSize = "40px"
    ),
    itemHoverStyle = list(
      color = 'gray'
    )   
  )
)

hc %>% hc_add_theme(thm)

