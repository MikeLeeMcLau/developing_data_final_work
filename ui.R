#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

shinyUI(pageWithSidebar(
  

  
  headerPanel("Quick Top Ten Graph"),
  
  
  sidebarPanel(
    #Selector for file upload
    fileInput('datafile', 'Pick Text/CSV file',
              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    #These column selectors are dynamically created when the file is loaded
    checkboxInput("getTestData","Use Diamond Data", FALSE),
    uiOutput("Select_X_Axis"),
    uiOutput("Select_Y_Axis"),
    #uiOutput("amountflag"),
    #The conditional panel is triggered by the preceding checkbox
    #conditionalPanel(
    #  condition="input.amountflag==true",
    #  uiOutput("amountCol")
    #),
    #The action button prevents an action firing before we're ready
    actionButton("getgeo", "View File"),
    actionButton("cleartable", "Clear Main Screen")
    
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Graph", plotOutput("getPlot")),
      tabPanel("Table", tableOutput("filetable")),
      tabPanel("Instructions",htmlOutput("textInstructions"))
    )  
    
  
)
))