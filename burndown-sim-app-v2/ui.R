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
    includeCSS("www/style.css"),
    # Application title ####
    titlePanel("Savings Burndown Simulation"),

    # Sidebar with a slider input for number of bins ####
    sidebarLayout(
      # sidebarPanel ####
        sidebarPanel(
            numericInput(inputId='nsims', '# of Simulations', value=100, min=1, max=5000, step=50),
            numericInput(inputId='nyrs', "# of Yrs", value=20, min=5, max=30, step=1),
            sliderInput(inputId = 'sbal', label='Starting Bal. Range', min=500000, max=3000000,
                        step=50000, value=800000, pre="$"),
            # % variables have Percent formatting + post="%"; ensure /100 in server.R calcs
            sliderInput(inputId='arr', label="Avg. Annual Return", "Percentage:",
                        value=4, min=2, max=12, step=0.25, post="%"),
            sliderInput(inputId='sdrr', label="Std. Dev. Return (assuming normal dist.)",
                        value=8, min=2, max=12, step=0.25, post="%"),
            sliderInput(inputId='maxrr', label="Max. Annual Return (realistically limited upside)", "Percentage:",
                        value=14, min=8, max=38, step=0.5, post="%"),
            sliderInput(inputId='draw', label="Annual Draw Range (how much needed to spend each yr)", 
                        value=c(60000,80000), min=20000, max=200000, step=5000, pre="$"),
            sliderInput(inputId='inflr', label="Avg. Annual Inflation Rate", "Percentage:",
                         value=3, min=1, max=12, step=0.5, post="%"),
            #actionButton(inputId='runsim', label="Run Sims")
            actionButton(inputId='runsim', label="Run Sims", style="material-flat", 
                         icon("play"), class="btn btn-success"),
        ),
        # mainPanel ####
        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            tabPanel("Results", # Results ####
            #plotOutput("distPlot"),
            h3("Results"),
            p("Select settings on left, then click 'Run Sims' to see how long your savings are likely to last. (may take a few seconds to load)"),
            plotlyOutput("burndownPlot"),
            plotlyOutput("probPlot"),
            plotlyOutput("returnHist"),
            #textOutput("returnHistCap"), # leaving this in, in case want to do dynamic percentiles later
            tags$div(
              class = "caption",
              HTML(
                "(<span style='color:red;'>Red</span>=mean, 
                <span style='color:blue;'>Blue</span>=median, 
                <span style='color:green'>Green</span>=10th/90th percentile.)" 
              )
            ),
            #> FOOTER ----
            tags$div(
              "© 2025 A", 
              tags$a(href="https://www.catbird-analytics.com/", 'Catbird Analytics'),
              " Production, John Yuill", 
              class="footer") # end of footer
          ), # end results tab
          tabPanel("About", # About ####
            h3("About this App"),
            h4("How long will your savings last?"),
            p(HTML("This app uses data simulation, based on user-defined parameters, to answer the question: 
              <strong>If I quit/lost/retired from my job today, how long would my savings last?</strong>")),
            p(HTML("This is done by taking the inputs as variables, 
              making some assumptions about how the variable values are may vary
              from the inputs provided (given uncertainty in the world), 
              and then doing numerous iterations of calculating the relationships between the variables
              to determine overall likelihood of savings lasting a given number of years. (aka Monte Carlo simulation)")),
            p(HTML("The results are displayed in a series of plots: 
              <ul>
              <li>line plot showing all the actual iterations of savings burning-down over time,</li> 
              <li><strong>probability line plot </strong>showing overall likelihood of money lasting to any given year,</li>
              <li>histogram of annual returns, just for reference.</ul>")),
            p(HTML("The idea is to help provide some context for financial planning, and life decisions. 
            Of course, 
              <strong>this is not a replacement for professional financial advice!</strong>, 
              The results are only as good as the inputs provided, the underlying assumptions, 
              and do not provide a guarantee of what will happen in the unknownable future.")),
            h4("Who did this?"),
            tags$p(HTML("Created by <strong>John Yuill</strong>, 
                        a data analyst and data product developer based in Vancouver, BC, Canada."), 
                  tags$br("Reach me on", 
                   tags$a(href="https://www.linkedin.com/in/johnyuill/", "LinkedIn.", class="non-tab"),
                   " for more info, questions, comments."))
          ) # end about tab
        ) # end of tabsetPanels
    ) # end of mainPanel
) # end sidebarLayout
) # end of fluidPage
) # end of shinyUI
