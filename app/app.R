ui <- fluidPage(
  "Hello Shiny!"
)

server <- function(input, output, session) {

  session$onSessionEnded(function() {
    stopApp()
  })

}

shinyApp(ui = ui, server = server)
