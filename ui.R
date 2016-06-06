
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(
  fluidPage(
    # Application theme
    theme = "style.css",
    # titlePanel(
    # 
    # ),
    
    fluidRow(
      column(12,
      # Show a plot of the generated distribution
      div(class="image", style="margin-bottom:50px;",
        img(width="100%", height="auto",
            src="https://api.mapbox.com/styles/v1/petermeissner/cip42lnww000pdjl4s67ds9hn/static/13.620863,54.092463,5.99,0.00,0.00/1200x400?access_token=pk.eyJ1IjoicGV0ZXJtZWlzc25lciIsImEiOiJjaWg2M2FvcmQwMDBsdnFseXVxbGNqMjQxIn0.sjwDM72Mu8FVseRUPWUVlQ"
          ),
        h1(
          "My First Shiny App", 
          style="
        position: absolute;
        top: 35px; 
        left: 0; 
        font-size: 350%; 
        margin-left: 20px; 
        font-style: italic;
        -webkit-text-stroke: 2px #ebebeb;
        text-shadow:
        3px 3px 0 #000,
        -1px -1px 0 #000,  
        1px -1px 0 #000,
        -1px 1px 0 #000,
        1px 1px 0 #000;
        ")
      ),
      tabsetPanel(
        type = "tabs",
        tabPanel("the app",
         column(12, h2("stock price")),
         column(12, plotOutput("tsplot") ),
         column(12,
                div(class="sbs", style="float: left; margin-right:10px",
                    selectInput(
                      inputId = "files", 
                      label = "data", 
                      choices = data_files
                    )),
                div(class="sbs", style="float: left; margin-right:10px",
                    selectInput(
                      inputId = "stock", 
                      label = "stock", 
                      choices = unique(data_store$name)
                    )),
                div(class="sbs", style="float: left;",
                    selectInput(
                      inputId = "botselection", 
                      label = "Bot", 
                      choices = ls(bots_store)
                    ))
                
         ),
         column(12, h2("bot performance") ),
         column(12, plotOutput("botplot") ),
         column(12, h2("bot definition") ),
         column(12,
                div(class="sbs", style="float: right;",
                    actionButton("eval", "Evaluate")
                )
         ),
         column(12,
                div(class="sbs", style="float: left; width: 50%",
                    "current bot definition",
                    aceEditor(
                      "botcode", 
                      fontSize = 14, 
                      mode = "r", 
                      height="1200px",
                      readOnly=TRUE,
                      theme = "solarized_dark",
                      value = ""
                    )),
                div(class="sbs", style="float: left; width: 50%",
                    "build your own bot",
                    aceEditor(
                      "manual_bot_ace", 
                      fontSize = 14, 
                      height="1200px",
                      mode = "r", 
                      theme = "solarized_dark",
                      autoComplete = "live",
                      value = paste(readLines("ace_init.R"), collapse = "\n")
                    ))
             )
        ),
          tabPanel("app info", suppressWarnings(includeMarkdown("app_info.md")) ),
          tabPanel("dev notes", suppressWarnings(includeMarkdown("dev_notes.md")) )
        ), 
      id="tabset"
      )
    )
  )
)
