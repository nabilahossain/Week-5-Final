library(shiny)
wd.datapath = paste0(getwd(),"/data")
wd.init = getwd()
setwd(wd.datapath)

midwest2 = read.csv("midwest.csv", header = TRUE)

setwd(wd.init)


#df.shiny = read.csv("C:/Users/sanjivek/Desktop/shine/data/midwest.csv")
#print(midwest2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Midwest State Demography Distribution"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      
      
      
      selectInput(inputId = "Stat", 
                  label = h4("Select Midwest State for Demographic details"),
                  choices = list("ILLINOIS", "MICHIGAN",
                                 "INDIANA", "WISCONSIN","OHIO"),
                  selected = "ILLINOIS")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      #tabsetPanel(tabPanel("Main",plotOutput("distPlot", height = 1000, width = 1000))
      
      plotOutput("distPlot")
    ))
  )
)

