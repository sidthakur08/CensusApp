source("helpers.R")

counties <- readRDS("counties.rds")

library(shiny)
library(maps)
library(mapproj)

# User interface ----
ui <- fluidPage(
  titlePanel("Census Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", 
                              "Percent Black",
                              "Percent Hispanic", 
                              "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      textOutput("text"),
      plotOutput("map")
      )
  )
)

# Server logic ----
server <- function(input, output) {
  output$text <- renderText(
    paste("You have selected ",input$var," for the range, ",input$range[1]," to ",input$range[2])
  )
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    color <- switch(input$var,
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    legend <- switch(input$var,
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color,legend,min = input$range[1],max = input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)
