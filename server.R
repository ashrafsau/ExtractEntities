# load required packages
library(tm)
library(NLP)
library(openNLP)
library(stringr)

# creating annotating objects
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
pos_tag_annotator <- Maxent_POS_Tag_Annotator()

# function to return rentities and frequencies
extract_patterns<-function(text){
  if(text=="") return (NA)
  A<-"([-a-zA-Z]+/JJ[RS ]?)" #regular expression for Adjective
  N<-"([-a-zA-Z]+/NN[SP]?[ ]?)" #regular expression for Noun
  P<-sprintf("%s*%s+",A,N)  # P=A*N+ [any number adjectives followed by one or more nouns]
  
  s <- as.String(text)
  a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))
  a3 <- annotate(s, pos_tag_annotator, a2)
  a3w <- subset(a3, type == "word")
  tags <- sapply(a3w$features, "[[", "POS")
  tagged_text<-paste(s[a3w], tags,sep="/", collapse =  " ")
  tagged_text<-str_replace_all(tagged_text,"\\)/","/")
  
  p<-str_trim(unlist(str_extract_all(string = tagged_text,pattern = P)))
  p<-str_replace_all(string = p,pattern = "/[:alpha:]+",replacement = "")
  p<-str_replace(string = p,pattern = "ies$",replacement = "y")
  p<-str_replace_all(p,'-',' ')
  p<-as.data.frame(table(p))
  df<-data.frame(Entity=p$p,Frequency=p$Freq)
  df<-df[order(df$Frequency,decreasing = T),]
  df
}

# function to return html code for input text to show in the page
html_text<-function(p){
  html<-'<h3>Extracted Entities :</h3><ol>'
  for(i in 1: length(p)){
    html<-paste(html,sprintf('<li>%s</li>',p[i]))
  }
  html<-paste(html,'</ol>')
  html
}


shinyServer(
  function(input, output) {
    # reactive function to call extract_patterns function on changes in input
    concepts <- reactive({extract_patterns(input$text)})
    
    # to show the extracted entities
    output$output_text <- renderDataTable(
      if (input$se > 0) concepts(),options = list(pageLength = 10)
      )
      
    # to show the text input provided by user  
    output$input_text <- renderUI({
      if (input$st > 0) HTML(text = sprintf('<h3>Entered Text:</h3><p align="justify">%s</p>',input$text))
      })
  }
)
