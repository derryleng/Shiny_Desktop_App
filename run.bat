@echo %off
setlocal enabledelayedexpansion
set AppDir=%~dp0
set R=%AppDir%R\bin\x64\R.exe
"%R%" --no-save --slave -f "%AppDir%run.R" --args "%AppDir:~0,-1%\app"
exit 0
