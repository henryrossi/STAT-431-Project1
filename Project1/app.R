#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(here)
library(plotly)

datByDegreesUnclean <- read_csv(here("Project1/degrees-that-pay-back.csv"))
datByCollegeUnclean <- read_csv(here("Project1/salaries-by-college-type.csv"))
datByRegionUnclean <- read_csv(here("Project1/salaries-by-region.csv"))

# Converting Salary columns from strings to numeric
datByDegrees <- datByDegreesUnclean %>% mutate(
  `Starting Median Salary` = as.numeric(gsub('[$,]', '', `Starting Median Salary`)),
  `Mid-Career Median Salary` = as.numeric(gsub('[$,]', '', `Mid-Career Median Salary`))
  )
datByCollege <- datByCollegeUnclean %>% mutate(
  `Starting Median Salary` = as.numeric(gsub('[$,]', '', `Starting Median Salary`)),
  `Mid-Career Median Salary` = as.numeric(gsub('[$,]', '', `Mid-Career Median Salary`))
)
datByRegion <- datByRegionUnclean  %>% mutate(
  `Starting Median Salary` = as.numeric(gsub('[$,]', '', `Starting Median Salary`)),
  `Mid-Career Median Salary` = as.numeric(gsub('[$,]', '', `Mid-Career Median Salary`))
)

dataChoices = c("Undergraduate Degree", "Type of College", "Region of College")

# Must correspond to the column names in the datasets
responseChoices = c("Starting Median Salary", "Mid-Career Median Salary")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Where it Pays to Attend College"),

    # Sidebar with selection inputs 
    sidebarLayout(
        sidebarPanel(
            selectInput("dataset",
                        "Data categorized by:",
                        choices = dataChoices),
            selectInput("response",
                        "Salary type:",
                        choices = responseChoices)
        ),

        # Show the plot
        mainPanel(
           plotlyOutput("salaryPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$salaryPlot <- renderPlotly({
      if(input$dataset == dataChoices[1]){
        datByDegrees %>%
          plot_ly(x = ~.data[[input$response]], color = ~`Undergraduate Major`, type = "box",
                  boxpoints = "all", jitter = 0.7, alpha = 0.5, pointpos = 0,
                  text = ~`Undergraduate Major`) %>%
          layout(title = 'Median Salary by Undergraduate Degree', 
                 xaxis = list(title = input$response), 
                 yaxis = list(showticklabels = FALSE, title = 'Undergaduate Degrees' ),
                 legend = list(title=list(text='<b> Degrees: </b>')))
        
        
        
      } else if(input$dataset == dataChoices[2]){
              datByCollege %>%
          plot_ly(x = ~.data[[input$response]], color = ~`School Type`, type = "box", 
                  boxpoints = "all", jitter = 0.7, alpha = 0.5, pointpos = 0,
                  text = ~`School Name`) |>
          layout(title = 'Salary Determined by Type of College', 
                 xaxis = list(title = input$response), 
                 yaxis = list(title = ' '), 
                 legend = list(title=list(text='Type of College')))
      } else if(input$dataset == dataChoices[3]){
        
        plot_ly(datByRegion, x = ~.data[[input$response]], color = ~Region,
                                type = "box", boxpoints = "all", jitter = 0.7,
                                alpha = 0.5, pointpos = 0, text = ~`School Name`) %>%
          layout(title = 'Salary Determined by Region', 
                 xaxis = list(title = input$response), 
                 yaxis = list(title = ' '), 
                 legend = list(title=list(text='Region')))
        
      }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
