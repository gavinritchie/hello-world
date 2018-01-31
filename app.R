library(shiny)
library(shinyHeatmaply)
library(grDevices)

players <- c('Jason','Dan','Gavin','Landon','Ryan','Josh','Hunter')
teams <- data.frame(matrix(0,nrow=length(players),ncol=length(players)))
colnames(teams) <- players
rownames(teams) <- players
for(i in 1:7) {
  teams[i,i] <- 0
}

ui <- fluidPage(
  actionButton('team1wins','Team 1 Wins'),
  actionButton('team2wins','Team 2 Wins'),
  selectInput('team11',"Team 1", choices = players),
  selectInput('team12',"", choices = players),
  selectInput('team21',"Team 2", choices = players),
  selectInput('team22',"", choices = players),
  plotlyOutput('plot'),
  tableOutput('table')
)

server <- function(input,output,session) {
  
  data <- reactive({
    teams[input$team11,input$team12] <- teams[input$team11,input$team12] + input$team1wins
    teams
  })
  
  output$table <- renderTable({
    data <- data()
    data
  })
  
  output$plot <- renderPlotly({
    data <- data()
    heatmaply(data, colors = heat.colors(50),revC = T)
  })
}

shinyApp(ui,server)
