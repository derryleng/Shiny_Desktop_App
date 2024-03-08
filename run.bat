@echo %off
setlocal enabledelayedexpansion

set "RootDir=%~dp0"
set "RPathFound=false"

:: First, try to find R in the portable directory
if exist "%RootDir%R\bin\x64\R.exe" (
    set "R=%RootDir%R\bin\x64\R.exe"
    set "RPathFound=true"
)

:: If not found, search for R in default installation paths
if not !RPathFound! == true (
    for %%d in ("C:\Program Files\R" "C:\Program Files (x86)\R") do (
        for /d %%i in (%%d\R-*) do (
            if exist "%%i\bin\x64\R.exe" (
                set "R=%%i\bin\x64\R.exe"
                set "RPathFound=true"
                goto :findDir
            )
        )
    )
)

:: If R is still not found, prompt the user
:promptRPath
if not !RPathFound! == true (
    set /p "R=Cannot detect R installation location. Please specify the full path to your R installation (R.exe): "
    if not exist "!R!" (
        echo The specified path does not exist. Please try again.
        goto :promptRPath
    ) else (
        set "RPathFound=true"
        echo.
        goto :findDir
    )
)

:: Assuming every folder contains a Shiny app, get a list of folders
:findDir
set /a "appCount=0"
for /d %%i in ("%RootDir%*") do (
    if "%%~nxi" neq "R" if "%%~nxi" neq "browser" (
        set /a "appCount+=1"
        set "app[!appCount!]=%%~nxi"
    )
)

:: Exit if no folders were found
if !appCount! EQU 0 (
    echo No Shiny apps were found, make sure you have at least one folder containing a Shiny app.
    pause >nul
)

:: For a single folder, skip app selection
if !appCount! EQU 1 (
    set "AppDir=%RootDir%!app[1]!"
    goto :runApp
)

echo ====== Shiny App Launcher ======
echo.
for /l %%i in (1,1,!appCount!) do (
    echo %%i. !app[%%i]!
)
echo.

:: Prompt the user to select an application
:selectApp
set /p opt="Select application to launch (1-!appCount!): "
set "opt=%opt:"=%"

:: Validate user input
echo %opt%| findstr /r /c:"^[1-9][0-9]*$" >nul 2>&1
if errorlevel 1 (
    echo Invalid input. Please enter a number between 1 and !appCount!.
    goto :selectApp
) else (
    if !opt! LEQ !appCount! (
        set "AppDir=%RootDir%!app[%opt%]!"
        goto :runApp
    ) else (
        echo Invalid input. Please enter a number between 1 and !appCount!.
        goto :selectApp
    )
)

:runApp
"%R%" --no-save --slave -f "%RootDir%run.R" --args "%AppDir%"

exit /b 0
