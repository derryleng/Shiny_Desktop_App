@echo %off
setlocal enabledelayedexpansion

set AppDir=%~dp0
set R="%AppDir%R\bin\x64\R.exe"
set runfile="%AppDir%run.R"
set appfolder="%AppDir%app"

%R% --no-save --slave -f %runfile% --args %appfolder%
exit 0
