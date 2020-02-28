# Deploying Shiny as Windows Desktop Application

This repository provides the required files and instructions on deploying R Shiny web applications as a installable and standalone local Windows desktop application.

The benefits of this deployment method is the minimal software requirement and IT knowledge necessary to run a Shiny application, making your Shiny app more accessible to end-users from all technical levels.

## Setup

### 1. Download this repository

### 2. Copy in Shiny app

Copy the contents of your Shiny app folder into the **app** folder (example included).

### 3. Specify R packages

Append the R packages you need to the **req.txt** file (one package per line).

(*Optional*) Loading packages in the Shiny app can take advantage of **req.txt** by using...

```
req <- scan(file.path(dirname(getwd()), "req.txt"), character(), quiet = T)
invisible(lapply(req, library, character.only = T))
```

...instead of usual library function calls:

```
library(shiny)
library(data.table)
library(leaflet)
...
```

### 4. Package Portable R Installation

Download and install [R Portable](https://sourceforge.net/projects/rportable/), then copy the contents of **R-Portable\App\R-Portable** (this should have folders such as *bin*, *doc*, *etc* and so on) into the **R** folder .

Inside the **R** folder, open **etc** and edit **Rprofile.site** using a text editor to include the lines:

```
.First = function(){
    .libPaths(.Library)
}
```

This will tell the R portable installation to only use the packages installed in this local directory, in case the user has other R installations on their machine.

### 5. (Optional) Package web browser

A portable Chrome browser is used in this example but other suitable browser may be also be used, you may remove the **chrome** folder if you are not packaging a web browser.

Download and install [Google Chrome Portable](https://portableapps.com/apps/internet/google_chrome_portable),  then copy the contents of **GoogleChromePortable\App\Chrome-bin** into the **chrome** folder.

Edit **run.R** and comment out the line (this runs the app in default browser):

```
shiny::runApp(appDir = file.path(x[1]), launch.browser = T)
```

And uncomment (and edit if necessary) the lines (this runs the app in the packaged Chrome browser):

```
# chrome <- file.path(dirname(x[1]), "chrome", "chrome.exe")
# shiny::runApp(
#   appDir = file.path(x[1]),
#   host = "127.0.0.1",
#   port = 8000,
#   launch.browser = function(shinyurl) {
#     system(paste(chrome, "--app=http://127.0.0.1:8000/ -incognito"), wait = F)
#   }
# )
```

NOTE: Many browsers have the option of running in kiosk mode, this removes address bars, bookmark bars and other features of a web browser to only display a single webpage, providing the closest experience to a regular desktop application; here kiosk mode is enabled by using **--app** followed by the URL of the Shiny app. **-incognito** is used to prevent Chrome from recorded cookies and history, to avoid needlessly bloating file size. The limitation of this approach is that we need to provide an explicit URL in the **system** function in order to launch in kiosk mode, meaning we cannot take advantage of random port assignment as a specific host and port must be provided in the **runApp** function. In this example if another app is running on port 8000 then the app will not be displayed after launching.

### 6. Create installer executable

Installers allow for easy distribution and installation of a Shiny desktop app. Software for creating Windows installer executable is required - I recommend [Inno Setup](https://www.jrsoftware.org/isinfo.php). The details for using this software is not specified here, but it would be preferable to provide a non-admin install option allowing for less privileged users easier access to the app.

### 7. Run the app

Double click **run.bat** to open the Shiny app in either the default browser or packaged web browser.

To shut down the app, both the web browser windows and command prompt window must be closed.

## Acknowledgements

Inspired by Lee Pang: https://www.r-bloggers.com/deploying-desktop-apps-with-r/
