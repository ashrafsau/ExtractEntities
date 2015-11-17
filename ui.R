shinyUI(pageWithSidebar(
  headerPanel("Entity extraction from Text"),
  sidebarPanel(
    textInput(inputId="text", label = "Input Text",width = '100%',placeholder = 'Enter text here'),
    actionButton("st", "Show Text"),
    actionButton("se", "Extract Entities"),
    htmlOutput('input_text')
    
  ),
  mainPanel(
    dataTableOutput('output_text')
  )
))
