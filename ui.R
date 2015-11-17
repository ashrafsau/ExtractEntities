shinyUI(pageWithSidebar(
  headerPanel("Entity extraction from Text"),
  sidebarPanel(
    # input text box
    textInput(inputId="text", label = "Input Text",width = '100%',placeholder = 'Enter text here'),
    actionButton("st", "Show Text"),
    actionButton("se", "Extract Entities"),
    htmlOutput('input_text') # to show entered text
    
  ),
  mainPanel(
    # to show output (extracted entities)
    dataTableOutput('output_text')
  )
))
