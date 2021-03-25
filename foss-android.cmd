@echo off
title=FOSS Apps for Android

cd /d "%~dp0"
if NOT "%cd%"=="%cd: =%" (
  echo The Current directory contains spaces in the path.
  echo Please move or rename the directory to on whos not contain spaces.
  echo.
  pause
  goto :EOF
)

:START_PROCESS
set "aria2=files\aria2c.exe"
set "adb=files\adb.exe"
set "destDir=Apps"

echo.
echo "This is a little script for my Favorites FOSS Apps for Android."
echo "This is a alternativ for GApps too."
echo.
echo "You can uninstall the unnecessary if you want!"
echo.
echo "Do you want to install these Applications"
echo "F-Droid"
echo "OSMAnd"
echo "Davx5"
echo "OpenTasks"
echo "NewPipe"
echo.
echo "Yes to install or No for not."
echo.
pause
