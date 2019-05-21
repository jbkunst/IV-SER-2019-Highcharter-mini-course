# Pacotes -----------------------------------------------------------------
library(highcharter)
library(tidyverse)

options(highcharter.theme = hc_theme_smpl())


# Exemplo motivacional ----------------------------------------------------
# 
# - http://jkunst.com/blog/posts/2016-03-24-how-to-weather-radials/
# - http://jkunst.com/blog/posts/2016-12-02-replicating-nyt-weather-app/
# 

# Documentação ------------------------------------------------------------
# 
# - https://www.highcharts.com/demo
# - http://jkunst.com/highcharter/highcharts.html
# 


# Muito tipos de graficos -------------------------------------------------
colors <- c("#d35400", "#2980b9", "#2ecc71", "#f1c40f", "#2c3e50", "#7f8c8d")
colors2 <- c("#000004", "#3B0F70", "#8C2981", "#DE4968", "#FE9F6D", "#FCFDBF")

gen_df <- function(n = 8) {
  
  tibble(x = seq_len(n) - 1) %>% 
    mutate(
      y = 10 + x + 10 * sin(x) + 5 * rnorm(length(x)),
      y = round(y, 0),
      y = abs(y),
      z = sample((x*y) - median(x*y)),
      e = 10 * abs(rnorm(length(x))) + 2,
      e = round(e, 1),
      low = y - e,
      high = y + e,
      value = y,
      name = fruit[str_length(fruit) <= 5][seq_len(n)],
      color = rep(colors, length.out = n),
      segmentColor = rep(colors2, length.out = n)
    )
} 

create_hc <- function(t = "line") {
  
  message(t)

  keep_rm_high_and_low <- c("arearange", "areasplinerange", "columnrange", "errorbar")
  
  add_2nd_series <- c("line", "spline", "streamgraph", "column", "scatter", "bubble")
  
  remove_colors <- c("line", "errorbar", "scatter", "column", "bar", "columnrange")
  
  is_polar <- str_detect(t, "polar")
  t <- str_replace(t, "polar", "")
  
  if(!t %in% dont_rm_high_and_low) {
    df1 <- df1 %>% select(-e, -low, -high)
    df2 <- df2 %>% select(-e, -low, -high)
  } 
  
  if(t %in% remove_colors) {
    df1 <- df1 %>% select(-color)
    df2 <- df2 %>% select(-color)
  }
  
  hc <- highchart() %>%
    hc_title(
      text = paste(ifelse(is_polar, "polar ", ""), t),
      style = list(fontSize = "15px")
      ) %>% 
    hc_chart(
      type = t,
      polar = is_polar
      ) %>% 
    hc_xAxis(
      categories = df1$name
      ) %>% 
    hc_add_series(df1, name = "Serie 1") 
  
  if(t %in% add_2nd_series) {
    hc <- hc %>% 
      hc_add_series(df2, name = "Serie 2") %>% 
      hc_plotOptions(series = list(showInLegend = TRUE)) 
    
  } else {
    hc <- hc %>% 
      hc_plotOptions(series = list(showInLegend = FALSE))
  }
  
  hc
  
}

df1 <- gen_df()
df2 <- gen_df()

hcs <- c(
  # basic
  "line", "spline",  "area", "areaspline",
  "column", "columnpyramid", "bar", 
  "scatter", "bubble",
  # special
  "waterfall" , "funnel", "pyramid",
  "pie" , "treemap", "packedbubble", "wordcloud", "item",
  # error 
  "arearange", "areasplinerange", "columnrange", "errorbar",
  "polygon",
  # polar
  "polarline", "polarcolumn", "polarcolumnrange",
  "coloredarea", "coloredline", "streamgraph")  %>% 
  map(create_hc) 

  
htmltools::browsable(highcharter::hw_grid(hcs))


# tilemap -----------------------------------------------------------------
url <- "https://gist.githubusercontent.com/maartenzam/787498bbc07ae06b637447dbd430ea0a/raw/9a9dafafb44d8990f85243a9c7ca349acd3a0d07/worldtilegrid.csv"

data <- read_csv(url)
data <- rename_all(data, str_replace_all, "\\.", "_")
data

hchart(data, "tilemap", hcaes(x = x, y = -y, name = name, group = region)) %>% 
  hc_chart(type = "tilemap") %>% 
  # hc_plotOptions(series = list(tileShape = "cirle")) %>% 
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        format = "{point.alpha_2}",
        color = "white",
        style = list(textOutline = FALSE)
      )
    )
  ) %>% 
  hc_tooltip(
    headerFormat = "",
    pointFormat = "<b>{point.name}</b> is in <b>{point.region}</b>"
  ) %>% 
  hc_xAxis(visible = FALSE) %>% 
  hc_yAxis(visible = FALSE)




# solidgauge --------------------------------------------------------------
col_stops <- data.frame(
  q = c(0.15, 0.4, .8),
  c = c('#55BF3B', '#DDDF0D', '#DF5353'),
  stringsAsFactors = FALSE
)

highchart() %>%
  hc_chart(type = "solidgauge") %>%
  hc_title(text = "solidgauge") %>%
  hc_pane(
    startAngle = -90,
    endAngle = 90,
    background = list(
      outerRadius = '100%',
      innerRadius = '60%',
      shape = "arc"
    )
  ) %>%
  hc_yAxis(
    stops = list_parse2(col_stops),
    lineWidth = 0,
    minorTickWidth = 0,
    tickAmount = 2,
    min = 0,
    max = 100,
    labels = list(y = 26, style = list(fontSize = "22px"))
  ) %>%
  hc_add_series(
    data = 90,
    dataLabels = list(
      y = -50,
      borderWidth = 0,
      useHTML = TRUE,
      style = list(fontSize = "40px")
    )
  )


# streamgraph -------------------------------------------------------------
# install.packages("ggplot2movies")
df <- ggplot2movies::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  summarise(n = sum(value)) %>% 
  ungroup()
df

hchart(df, "streamgraph", hcaes(year, n, group = genre)) %>% 
  hc_yAxis(visible = FALSE)

# sankey ------------------------------------------------------------------
UKvisits <- data.frame(origin=c(
  "France", "Germany", "USA",
  "Irish Republic", "Netherlands",
  "Spain", "Italy", "Poland",
  "Belgium", "Australia", 
  "Other countries", rep("UK", 5)),
  visit=c(
    rep("UK", 11), "Scotland",
    "Wales", "Northern Ireland", 
    "England", "London"),
  weights=c(
    c(12,10,9,8,6,6,5,4,4,3,33)/100*31.8, 
    c(2.2,0.9,0.4,12.8,15.5)))

hchart(UKvisits, "sankey", hcaes(from = origin, to = visit, weight = weights))


energy <- paste0(
  "https://cdn.rawgit.com/christophergandrud/networkD3/",
  "master/JSONdata/energy.json"
) %>% 
  jsonlite::fromJSON()

dfnodes <- energy$nodes %>% 
  map_df(as_data_frame) %>% 
  mutate(id = row_number() - 1)

dflinks <- tbl_df(energy$links)

dflinks <- dflinks %>% 
  left_join(dfnodes %>% rename(from = value), by = c("source" = "id")) %>% 
  left_join(dfnodes %>% rename(to = value), by = c("target" = "id")) 

hchart(dflinks, "sankey", hcaes(from = from, to = to, weight = value))

# vector ------------------------------------------------------------------
x <- seq(5, 100, by = 5)

df <- expand.grid(x = x, y = x) %>% 
  mutate(
    l = 200 - (x + y),
    d = (x + y)/200 * 360
  )

hchart(df, "vector", hcaes(x, y, length = l, direction = d),
       color = "black", name = "Sample vector field")  %>% 
  hc_yAxis(min = 0, max = 100)

# xrange ------------------------------------------------------------------
library(lubridate)

N <- 7
set.seed(1234)
df <- data_frame(
  start = Sys.Date() + months(sample(10:20, size = N)),
  end = start + months(sample(1:3, size = N, replace = TRUE)),
  cat = rep(1:5, length.out = N) - 1,
  progress = round(runif(N), 1)
)

df <- mutate_if(df, is.Date, datetime_to_timestamp)

hchart(df, "xrange", hcaes(x = start, x2 = end, y = cat, partialFill = progress),
       dataLabels = list(enabled = TRUE)) %>% 
  hc_xAxis(type = "datetime") %>% 
  hc_yAxis(categories = c("Prototyping", "Development", "Testing", "Validation", "Modelling"))

# wordclouds --------------------------------------------------------------
library(rvest)
texts <- read_html("http://www.htmlwidgets.org/develop_intro.html") %>% 
  html_nodes("p") %>% 
  html_text()

data <- texts %>% 
  map(str_to_lower) %>% 
  reduce(str_c) %>% 
  str_split("\\s+") %>% 
  unlist() %>% 
  data_frame(word = .) %>% 
  count(word, sort = TRUE) %>% 
  anti_join(tidytext::stop_words) %>% 
  head(50)

data

hchart(data, "wordcloud", hcaes(name = word, weight = n))


