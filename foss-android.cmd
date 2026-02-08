@echo off
setlocal EnableExtensions EnableDelayedExpansion
title=FOSS Apps for Android

cd /d "%~dp0"
if NOT "%cd%"=="%cd: =%" (
  echo The Current directory contains spaces in the path.
  echo Please move or rename the directory to one without spaces.
  echo.
  pause
  goto :EOF
)

set "aria2c=files\aria2c.exe"
set "adb=files\adb.exe"
set "destDir=Apps"

if NOT EXIST "%aria2c%" goto :NO_ARIA2
if NOT EXIST "%adb%" goto :NO_ADB
if NOT EXIST "%destDir%" mkdir "%destDir%"

:main
cls
echo.
echo ###############################################################
echo                  Kev-Dev1 script Project
echo.
echo  You can help me with my Project
echo  When you have a Idea or you find a Bug, please create a
echo  Issues on Github to this Project.
echo.
echo  Github: https://github.com/kev-dev1
echo.
echo ################################################################
echo.
echo This is a little script for my Favorites FOSS Apps for Android.
echo This is a alternativ for GApps too.
echo.
echo You can uninstall the unnecessary if you want!
echo.
echo Do you want to install these Applications
echo "F-Droid"
echo "OSMAnd"
echo "Davx5"
echo "OpenTasks"
echo "NewPipe"
echo "FlorisBoard"
echo.
echo Type [Y] to install, [N] for not or [E] for exit
echo Or type Exit to close this script!
echo.
set /p enter="Choose: "
if /i "%enter%"=="Y" goto download
if /i "%enter%"=="N" goto exit
if /i "%enter%"=="E" goto EOF
echo.
echo Please type correct!
echo.
pause
goto main

:download
cls
echo.
echo Download starts...
echo.

call :DOWNLOAD_FIXED "F-Droid" "https://f-droid.org/F-Droid.apk" "F-Droid.apk" || exit /b 1
call :DOWNLOAD_LATEST_FDROID "OSMAnd" "net.osmand.plus" || exit /b 1
call :DOWNLOAD_LATEST_FDROID "Davx5" "at.bitfire.davdroid" || exit /b 1
call :DOWNLOAD_LATEST_FDROID "OpenTasks" "org.dmfs.tasks" || exit /b 1
call :DOWNLOAD_LATEST_FDROID "NewPipe" "org.schabi.newpipe" || exit /b 1
call :DOWNLOAD_LATEST_FDROID "FlorisBoard" "dev.patrickgold.florisboard" || exit /b 1

goto check

:DOWNLOAD_FIXED
set "APP_NAME=%~1"
set "APP_URL=%~2"
set "APP_FILE=%~3"
echo Downloading %APP_NAME%...
"%aria2c%" -d "%destDir%" --no-conf --allow-overwrite=true --file-allocation=none "%APP_URL%"
if errorlevel 1 call :DOWNLOAD_ERROR & exit /b 1
set "APK_%APP_NAME%=%APP_FILE%"
echo Download complete: %APP_FILE%
echo.
exit /b 0

:DOWNLOAD_LATEST_FDROID
set "APP_NAME=%~1"
set "PACKAGE_ID=%~2"
set "APP_URL="
set "APP_FILE="

for /f "usebackq delims=" %%U in (`powershell -NoProfile -Command "$html=(Invoke-WebRequest -UseBasicParsing -Uri 'https://f-droid.org/packages/%PACKAGE_ID%/').Content; $m=[regex]::Match($html,'https://f-droid.org/repo/[^\" ]+\.apk'); if($m.Success){$m.Value}"`) do set "APP_URL=%%U"

if not defined APP_URL (
  echo Failed to resolve latest APK for %APP_NAME% ^(%PACKAGE_ID%^).
  exit /b 1
)

for %%F in ("%APP_URL%") do set "APP_FILE=%%~nxF"

echo Downloading %APP_NAME%...
"%aria2c%" -d "%destDir%" --no-conf --allow-overwrite=true --file-allocation=none "%APP_URL%"
if errorlevel 1 call :DOWNLOAD_ERROR & exit /b 1

set "APK_%APP_NAME%=%APP_FILE%"
echo Download complete: %APP_FILE%
echo.
exit /b 0

:check
cls
echo.
echo Check on your Android Device is ADB-Debugging active.
echo.
"%adb%" devices
echo.
echo Is your Android Device in the list?
echo [Y]es or [N]o
set /p adbAnswer=
if /i "%adbAnswer%"=="Y" goto install
if /i "%adbAnswer%"=="N" goto check_ERROR
goto check

:install
cls
echo.
echo Install starting...
echo.

call :INSTALL_APP "F-Droid"
call :INSTALL_APP "OSMAnd"
call :INSTALL_APP "Davx5"
call :INSTALL_APP "OpenTasks"
call :INSTALL_APP "NewPipe"
call :INSTALL_APP "FlorisBoard"
goto finish

:INSTALL_APP
set "APP_NAME=%~1"
set "APP_FILE=!APK_%APP_NAME%!"
if not defined APP_FILE (
  echo Missing downloaded file for %APP_NAME%.
  exit /b 1
)
echo Install %APP_NAME%...
"%adb%" install "%destDir%\!APP_FILE!"
echo Install complete!
echo.
exit /b 0

:exit
cls
echo.
echo Oh, Sorry for you. The FOSS Apps are good.
echo.
pause
exit

:finish
cls
echo.
echo Have a Nice day with your Android FOSS Device!!
echo.
pause
exit

:check_ERROR
cls
echo.
echo Please check that your Android Device has ADB-Debugging active.
echo.
pause
goto check

:DOWNLOAD_ERROR
echo.
echo Error on downloading the Files.
echo Please check your Internet connection or try again later.
echo.
pause
exit /b 1

:NO_ARIA2
cls
echo.
echo Aria2 not found.
echo.
echo Please download Aria2c from https://aria2.github.io/
echo.
pause
exit

:NO_ADB
cls
echo.
echo Please check in the files folder that adb.exe exists.
echo If not, download the script again.
echo.
pause
exit

:EOF
