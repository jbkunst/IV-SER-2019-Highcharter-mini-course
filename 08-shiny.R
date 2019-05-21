# Pacotes -----------------------------------------------------------------
library(highcharter)
library(tidyverse)
library(shiny)

# Documentação ------------------------------------------------------------
# 
# - https://shiny.rstudio.com/
# - http://www.htmlwidgets.org/
# - https://cran.r-project.org/web/packages/highcharter/vignettes/shiny-events-demo.html

# Exemplo motivacional ----------------------------------------------------
# 
# - http://www.piaschile.cl/mercado/benchmarking-internacional/
# - https://github.com/jbkunst/shiny-apps-highcharter/tree/master/piramid-census
# 

shinyApp(
  ui = fluidPage(
    h1("mouseOver and click points for additional information"),
    uiOutput("click_ui"),
    uiOutput("mouseOver_ui"),
    highchartOutput("plot_hc")
  ),
  server = function(input, output) {
    
    df <- tibble(x = 1:10, y = sample(x), otherInfo = letters[seq_len(x)])
    
    output$plot_hc <- renderHighchart({
      
      highchart() %>%
        hc_add_series(df, "scatter") %>%
        hc_add_event_point(event = "click") %>%
        hc_add_event_point(event = "mouseOver")
      
    })
    
    observeEvent(input$plot_hc, print(paste("plot_hc", input$plot_hc)))
    
    output$click_ui <- renderUI({
      
      if(is.null(input$plot_hc_click)) return()
      
      wellPanel("Coordinates of clicked point: ",input$plot_hc_click$x, input$plot_hc_click$y)
      
    })
    
    output$mouseOver_ui <- renderUI({
      
      if(is.null(input$plot_hc_mouseOver)) return()
      
      wellPanel("Coordinates of mouseOvered point: ",input$plot_hc_mouseOver$x, input$plot_hc_mouseOver$y)
      
    })
    
  }
  
)
