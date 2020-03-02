# How to import packages listed in req.txt
req <- scan(file.path(dirname(getwd()), "req.txt"), character(), quiet = T)
invisible(lapply(req, library, character.only = T))

ui <- fluidPage(
  "Hello Shiny!"
)

server <- function(input, output, session) {

  session$onSessionEnded(function() {
    stopApp()
  })
  
}

shinyApp(ui = ui, server = server)
