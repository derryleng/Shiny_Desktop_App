wd <- commandArgs(T)[1] # Shiny app directory
rd <- dirname(wd) # Root repo directory

if (is.na(wd)) {

  stop("Please use run.bat to launch the application.")

} else {

  # Get packages listed in req.txt
  req <- readLines(file.path(rd, "req.txt"))

  # Set correct package install location if there is bundled R
  lib_path <- if (
    file.exists(file.path(rd, "R", "bin", "R.exe")) &
    .libPaths()[1] != file.path(rd, "R", "library")
  ) {
    file.path(rd, "R", "library")
  } else {
    .libPaths()[1]
  }

  # Install missing packages
  if (length(req) > 0) {
    missing_packages <- req[!(req %in% installed.packages()[,"Package"])]
    if (length(missing_packages) > 0) {
      install.packages(
        missing_packages,
        lib = lib_path,
        repos = "https://cloud.r-project.org",
        clean = T
      )
    }
  }

  # Load packages
  suppressPackageStartupMessages(invisible(lapply(req, library, character.only = T)))

  # Run app
  browser_path <- file.path(rd, "chrome", "chrome.exe")
  if (file.exists(browser_path)) {

    # Open in embedded browser (must use a specific port)
    shiny::runApp(
      appDir = file.path(wd),
      launch.browser = function(shinyurl) {
        system(paste0("\"", browser_path, "\" --app=", shinyurl, " -incognito"), wait = F)
      }
    )

  } else {

    # Open in default web browser
    shiny::runApp(appDir = file.path(wd), launch.browser = T)

  }

}
