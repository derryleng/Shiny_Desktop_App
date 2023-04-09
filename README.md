# Deploying Shiny as Windows Desktop Application

This repository provides the required files and instructions on deploying R Shiny web application(s) as an installable and standalone local Windows desktop application.

The benefits of this deployment method is the minimal software requirement and IT knowledge necessary to run a Shiny application, making Shiny apps more accessible to users from all technical levels.

# Setup

### 1. Download this repository

This repository is a template of the base directory of desktop deployed Shiny app.

### 2. Package portable R installation

Download and install [R Portable](https://sourceforge.net/projects/rportable/), then copy the contents of **R-Portable\App\R-Portable** (this should have folders such as *bin*, *doc*, *etc* and so on) into the **R** folder. *Using a standard installation of R instead of R Portable should also work, but it is best to use a fresh installation to avoid bloat from including redundant packages.*

Inside the **R** folder, open **etc** and edit **Rprofile.site** using a text editor to include the lines:

``` R
.First = function(){
    .libPaths(.Library)
}
```

This will tell the R portable installation to only use the packages installed in this local directory, to avoid conflicts with other R installations.

### 3. (Optional) Package web browser

A portable Chrome browser is used in this example but other suitable browsers may be also be used, the **browser** folder can be removed if a web browser is not packaged.

Download and install [Google Chrome Portable](https://portableapps.com/apps/internet/google_chrome_portable),  then copy the contents of **GoogleChromePortable\App\Chrome-bin** into the **chrome** folder.

Edit **run.R** and comment the line (this runs the app in default browser):

``` R
shiny::runApp(appDir = file.path(x[1]), launch.browser = T)
```

And uncomment these lines (this runs the app in the packaged Chrome browser):

``` R
# browser_path <- file.path(dirname(x[1]), "chrome", "chrome.exe")
# shiny::runApp(
#   appDir = file.path(x[1]),
#   launch.browser = function(shinyurl) {
#     system(paste0("\"", browser_path, "\" --app=", shinyurl, " -incognito"), wait = F)
#   }
# )
```

In the code above, the arguments to *launch.browser* will launch Chrome in kiosk mode, which removes address bars, bookmark bars and other features, providing the closest experience to a regular desktop application.

If another browser is used, be sure to adjust *browser_path* and *launch.browser* arguments accordingly.

### 4. Copy in Shiny app

Copy the contents of the folder containing your Shiny app into the **app** folder (example included).

### 5. Installing R packages

Append the R packages used in the copied Shiny app to the **req.txt** file (one package per line).

Open R.exe (found in **R\bin**) and install Shiny. If not following optional steps below, all other requirements will also need to be installed at this stage.

``` R
install.packages("shiny")
```

(Optional) Deployment file size can be significantly reduced by configuring additional packages to be installed by the user on first run by including this at the start of the **app.R** or **global.R** file:

``` R
(function(req_file, install = T, update = F, silent = F) {

  # Read text file containing required packages
  req <- scan(req_file, character(), quiet = T)

  # Update packages
  if (update) {
    update.packages(repos = "https://cloud.r-project.org", ask = F)
  }

  # Install missing packages
  if (length(req) > 0 & install) {
    missing_packages <- req[!(req %in% installed.packages()[,"Package"])]
    if (length(missing_packages) > 0) {
      install.packages(
          missing_packages,
          repos = "https://cloud.r-project.org",
          dependencies = T,
          clean = T
      )
    }
  }

  # Additional stuff here
  # if (!webshot::is_phantomjs_installed()) {
  #   webshot::install_phantomjs()
  # }

  # Load packages
  if (silent) {
    suppressPackageStartupMessages(invisible(lapply(req, library, character.only = T)))
  } else {
    lapply(req, library, character.only = T)
  }


})("req.txt", silent = F)
```

This function takes advantage of the **req.txt** and automatically install missing CRAN packages and then loads all packages into the environment (i.e. *library* functions calls are not needed).

### 6. Loading R packages

*If using the optional function from the previous step, this step is not needed.*

Usual *library* function calls can be used:

``` R
library(shiny)
library(data.table)
library(leaflet)
...
```

Alternatively, the Shiny app can take advantage of **req.txt** by using:

``` R
req <- scan(file.path(dirname(getwd()), "req.txt"), character(), quiet = T)
invisible(lapply(req, library, character.only = T))
```

### 7. Terminating app on window close

To ensure that the Shiny app is automatically terminated when the browser window is closed by the user, the following should be added to the **server** function (make sure that *session* is added as an argument to the **server** function):

``` R
session$onSessionEnded(function() {
    stopApp()
})
```

### 8. Test run the app

Double clicking **run.bat** should now run the Shiny app in either the default browser or packaged web browser.

Closing the browser window should terminate the Shiny app and close the command prompt window.

### 9. (Optional) Packaging multiple Shiny apps

Several Shiny apps may be bundled into a single deployment, each Shiny app should be contained within its own folder inside the file directory.

Replace the contents of **run.bat** with the following example:

``` bat
@echo %off
setlocal enabledelayedexpansion

set BaseDir=%~dp0
set R=%BaseDir%R\bin\x64\R.exe

:select
echo ====== Shiny App Launcher ======
echo.
echo 1. Example App 1
echo 2. Example App 2
echo 3. Example App 3
echo.
set /p opt="Select application to launch (1-3): "

set AppDir=
if %opt%==1 (
	set "AppDir=%BaseDir%Example_App_1"
) else if %opt%==2 (
	set "AppDir=%BaseDir%Example_App_2"
) else if %opt%==3 (
	set "AppDir=%BaseDir%Example_App_3"
) else (
	echo Error, invalid input. Try again:
	echo.
	goto :select
)

"%R%" --no-save --slave -e "setwd(commandArgs(T)[1]); shiny::runApp(appDir = commandArgs(T)[1], launch.browser = T)" --args "%AppDir%"

exit 0
```

This example assumes you have three Shiny apps called *Example_App_1*, *Example_App_2*, and *Example_App_3*, change this and the corresponding selection options (in *echo*) to whatever suits you.

This allows the user to select the Shiny application to run via the command prompt window after clicking **run.bat**.

### 10. Create installer executable

Installers allow for easy distribution and installation of a Shiny desktop app. 

See setup.iss for an example compilation script using [Inno Setup](https://www.jrsoftware.org/isinfo.php). You will need to generate a new AppId and change the name, version, etc.

## Acknowledgements

Inspired by Lee Pang (he also has a repo on this topic [here](https://github.com/wleepang/DesktopDeployR)): https://www.r-bloggers.com/deploying-desktop-apps-with-r/
