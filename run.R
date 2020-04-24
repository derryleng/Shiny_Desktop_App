x <- commandArgs(T)
if (!is.na(x[1])) {
  
  req <- readLines(file.path(dirname(x[1]), "req.txt"))
  if (length(req) > 0) {
    missing_packages <- req[!(req %in% installed.packages()[,"Package"])]
    if (length(missing_packages) > 0) {
      install.packages(missing_packages, repos = "https://cloud.r-project.org", dependencies = T)
      # Include additional commands to be run after first time installation of package(s), e.g.
      # if (!webshot::is_phantomjs_installed()) {
      #   webshot::install_phantomjs()
      # }
    }
  }
  
  # Open in default web browser
  shiny::runApp(appDir = file.path(x[1]), launch.browser = T)
  
  # Open in embedded browser (must use a specific port)
  # browser_path <- file.path(dirname(x[1]), "chrome", "chrome.exe")
  # shiny::runApp(
  #   appDir = file.path(x[1]),
  #   launch.browser = function(shinyurl) {
  #     system(paste0("\"", browser_path, "\" --app=", shinyurl, " -incognito"), wait = F)
  #   }
  # )
  
} else {
  stop("Please use run.bat to launch the application.")
}
