#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(scales)
library(lubridate)
library(DT)
library(RColorBrewer)
library(gridExtra)
library(here)
library(plotly)
library(shinyWidgets)

options(scipen = 10)
dollar_format(accuracy=1000)

theme_set(theme_bw())

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Savings Burndown Simulation"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId='nsims', '# of Simulations', value=100, min=1, max=5000, step=50),
            numericInput(inputId='nyrs', "# of Yrs", value=20, min=5, max=30, step=1),
            sliderInput(inputId = 'sbal', label='Starting Bal. Range', min=500000, max=3000000,
                        step=50000, value=800000, pre="$"),
            # % variables have Percent formatting + post="%"; ensure /100 in server.R calcs
            sliderInput(inputId='arr', label="Avg. Annual Return", "Percentage:",
                        value=4, min=2, max=12, step=0.25, post="%"),
            sliderInput(inputId='sdrr', label="Std. Dev. Return",
                        value=8, min=2, max=12, step=0.25, post="%"),
            sliderInput(inputId='maxrr', label="Max. Annual Return", "Percentage:",
                        value=14, min=8, max=38, step=0.5, post="%"),
            sliderInput(inputId='draw', label="Annual Draw Range", 
                        value=c(60000,80000), min=20000, max=200000, step=5000, pre="$"),
            sliderInput(inputId='inflr', label="Avg. Annual Inflation Rate", "Percentage:",
                         value=3, min=1, max=12, step=0.5, post="%"),
            #actionButton(inputId='runsim', label="Run Sims")
            actionButton(inputId='runsim', label="Run Sims", style="material-flat", 
                         icon("play"), class="btn btn-success"),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            #plotOutput("distPlot"),
            h3("Results"),
            p("Select settings on left, then click 'Run Sims' to see how long your savings are likely to last. (may take a few seconds to load)"),
            plotlyOutput("burndownPlot"),
            plotlyOutput("probPlot"),
            plotlyOutput("returnHist"),
        )
    )
))
