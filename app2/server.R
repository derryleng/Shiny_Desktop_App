server <- function(input, output, session) {

  session$onSessionEnded(function() {
    stopApp()
  })

}
