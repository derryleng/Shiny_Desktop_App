# Deploying Shiny as Windows Desktop Application

This repository provides the required files and instructions on deploying R Shiny web applications as an installable and standalone local Windows desktop application.

The benefits of this deployment method is the minimal software requirement and IT knowledge necessary to run a Shiny application, making Shiny apps more accessible to users from all technical levels.

## Setup

### 1. Download this repository

### 2. Copy in Shiny app

Copy the contents of the folder containing the relevant Shiny app into the **app** folder (example included).

### 3. Specify R packages

Append the R packages used in the copied Shiny app to the **req.txt** file (one package per line).

(*Optional*) Code for loading packages in the Shiny app can take advantage of **req.txt** by using:

```
req <- scan(file.path(dirname(getwd()), "req.txt"), character(), quiet = T)
invisible(lapply(req, library, character.only = T))
```

Instead of usual library function calls:

```
library(shiny)
library(data.table)
library(leaflet)
...
```

### 4. Package Portable R Installation

Download and install [R Portable](https://sourceforge.net/projects/rportable/), then copy the contents of **R-Portable\App\R-Portable** (this should have folders such as *bin*, *doc*, *etc* and so on) into the **R** folder.

Inside the **R** folder, open **etc** and edit **Rprofile.site** using a text editor to include the lines:

```
.First = function(){
    .libPaths(.Library)
}
```

This will tell the R portable installation to only use the packages installed in this local directory, to avoid compatibility issues if the user has other R installations on their machine.

### 5. (Optional) Package web browser

A portable Chrome browser is used in this example but other suitable browser may be also be used, the **chrome** folder can be removed if the web browser is not packaged or appropriately renamed if another browser is used (*browser_path* in **run.R** will also need to be adjusted for alternative browsers).

Download and install [Google Chrome Portable](https://portableapps.com/apps/internet/google_chrome_portable),  then copy the contents of **GoogleChromePortable\App\Chrome-bin** into the **chrome** folder.

Edit **run.R** and comment the line (this runs the app in default browser):

```
shiny::runApp(appDir = file.path(x[1]), launch.browser = T)
```

And uncomment these lines (this runs the app in the packaged Chrome browser):

```
# browser_path <- file.path(dirname(x[1]), "chrome", "chrome.exe")
# shiny::runApp(
#   appDir = file.path(x[1]),
#   launch.browser = function(shinyurl) {
#     system(paste0("\"", browser_path, "\" --app=", shinyurl, " -incognito"), wait = F)
#   }
# )
```

In the code above, the argument to *launch.browser* will launch Chrome in kiosk mode, which removes address bars, bookmark bars and other features, providing the closest experience to a regular desktop application.

### 6. Create installer executable

Installers allow for easy distribution and installation of a Shiny desktop app. Software for creating Windows installer executable is required - I recommend [Inno Setup](https://www.jrsoftware.org/isinfo.php). The details for using this software is not specified here, but it would be preferable to provide non-admin users easier access to the app.

### 7. Terminating app on window close

To ensure that the Shiny app is automatically terminated when the browser window is closed by the user, the following should be added to the **server** function (make sure that *session* is added as an argument to the **server** function):

```
session$onSessionEnded(function() {
    stopApp()
})
```

### 8. Run the app

Double click **run.bat** to run the Shiny app in either the default browser or packaged web browser.

Closing the browser window will terminate the Shiny app and close the command prompt window.

## Acknowledgements

Inspired by Lee Pang: https://www.r-bloggers.com/deploying-desktop-apps-with-r/
