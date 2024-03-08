# Deploy Shiny app(s) locally on Windows

Use this repo as a template for deploying Shiny apps as standalone Windows desktop applications.

- Copy in Shiny apps (each in a separate folder) - see **app** and **app2** folders as example.
- Optionally bundle in a portable R installation ([see below](#bundle-a-portable-r-installation)).
- Optionally bundle in a web browser ([see below](#bundle-a-portable-web-browser)).
- Optionally package as installer executable ([see below](#create-installer-executable)).
- Double click run.bat to select and launch an app.

## Bundle a portable R installation

There are two options:

1. Install [R Portable](https://sourceforge.net/projects/rportable/), then copy the contents of **R-Portable\App\R-Portable\\** into the **R** folder.
2. Install a fresh installation of R (to avoid including packages the end-user may not use) and copy into the **R** folder.

Put any package dependencies in **req.txt** one per line, these will be loaded in **run.R** or installed if missing on first run.

## Bundle a portable web browser

Download and install [Google Chrome Portable](https://portableapps.com/apps/internet/google_chrome_portable), then copy the contents of **GoogleChromePortable\App\Chrome-bin\\** into the **chrome** folder.

Other suitable browsers may be also be used, but make sure to change *browser_path* in **run.R**.

## Create installer executable

See setup.iss for an example compilation script using [Inno Setup](https://www.jrsoftware.org/isinfo.php).

Make sure to generate a new AppId and change the name, version, etc.

## Extra tips

### Terminating app on window close

To allow the app to terminate when the browser window is closed, the following should be added to the *server* function:

> Note that *session* must be added as an argument to the *server* function

``` R
server <- function(input, output, session) {

  ...

  session$onSessionEnded(function() {
    stopApp()
  })

}
```
