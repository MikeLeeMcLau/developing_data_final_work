#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library("ggplot2")
library("plyr")

shinyServer(function(input, output) {
  
  
  output$textInstructions <- renderUI({
    HTML("<h4><ul>
    <li>This application will return a table and graph with the top ten values from a text file</li>
    <li>File Must be deliminted with comma and have the column name in the first row</li>
    <li>Select the Diamond check box if no file is available to upload</li>
    <li>X - Axis will populate with non-numeric fields.  Y - Axis will only populate with numeric fields</li>
    <li>Select X and Y data and click View File.   Graph will appear on Graph tab and table will be on table tab</li>
    <li>Currently the app will only sum data</li>
    <li>Check box must be unselected to view uploaded data</li>
    </ul></h4>"
    )
  })
 
  
  #This function is repsonsible for loading in the selected file

  filedata <- reactive({
    if(input$getTestData=="FALSE") {
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    
    #if(input$getTestData=="FALSE") {  
      read.csv(infile$datapath)
    }
    
    else {
       data.frame(diamonds)
    }
      

    
  })
  
  
  #The following set of functions populate the column selectors
  output$Select_X_Axis <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    #only show text data
    txt <- sapply(df, is.numeric)
    items=names(txt[txt==FALSE])
    names(items)=items
    selectInput("Select_X_Axis", "Select X Axis:",items)
  
  })    
  
  output$Select_Y_Axis <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    #Let's only show numeric columns
    nums <- sapply(df, is.numeric)
    items=names(nums[nums])
    names(items)=items
    selectInput("Select_Y_Axis", "Y Axis:",items)

  })
  

  
    

  #This function is the one that is triggered when the action button is pressed
  #Pressing the button triggers the actions.
  geodata <- observeEvent(input$getgeo , { 
    if (input$getgeo == 0) return(NULL)
    #This previews the CSV data file
    dfSort <- filedata()
    dfSort <- aggregate(list(Values=dfSort[,input$Select_Y_Axis]) , by=list(Category=dfSort[,input$Select_X_Axis]), FUN=sum)
    dfSortPlot <- head(arrange(dfSort,desc(Values)), n = 10)
    #dfSort$CountX <- input$Select_Y_Axis
    strText <-  input$Select_Y_Axis
    
    output$getPlot <- renderPlot( {
      
      ggplot(dfSortPlot, aes(x=dfSortPlot[,1], y=dfSortPlot[,2])) +
        geom_bar(stat='identity',fill="blue", colour="black") +
        xlab("Category") +  ylab("") +
        coord_flip() +
        scale_fill_hue() +
        theme_bw()
      
    })
    
    
    
    output$filetable <- renderTable({
       #filedata()
      dfSortPlot
    })
    
    
 
  #  
  #  #output$text <- renderText(strText)
  #  dfSort <- head(arrange(filedata(),desc(strText)), n = 10)
    
    
    
})
  

  tableclear <- observeEvent(input$cleartable , {
    if (input$cleartable == 0) return(NULL)
    output$filetable <- renderTable({
    NULL
    })
    output$getPlot <- renderPlot( {
      NULL
    })
    
  })  


  
})
