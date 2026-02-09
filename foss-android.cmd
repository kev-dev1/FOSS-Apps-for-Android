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
echo  Github: https://github.com/kev-dev1
echo.
echo ################################################################
echo.
echo These apps will be downloaded:
echo "F-Droid"
echo "Firefox"
echo "Thunderbird"
echo "FlorisBoard"
echo "Breezy Weather"
echo "Obtainium"
echo "OSMAnd"
echo "Aurora Store"
echo.
echo Type [Y] to install, [N] for not or [E] for exit
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
echo Download starts...
echo.

call :DOWNLOAD_FIXED "F-Droid" "https://f-droid.org/F-Droid.apk" "F-Droid.apk" || exit /b 1
call :DOWNLOAD_FROM_POWERSHELL "Firefox" "$base='https://download.cdn.mozilla.net/pub/fenix/releases/'; $dir=((Invoke-WebRequest -UseBasicParsing -Uri $base).Links.href | ?{$_ -match '^v\d+\.\d+\.\d+/$'} | sort-object {[version]($_.TrimEnd('/').TrimStart('v'))} | select -Last 1); if(-not $dir){exit 1}; $release=$base+$dir; $apk=((Invoke-WebRequest -UseBasicParsing -Uri $release).Links.href | ?{$_ -match 'fenix-.*arm64-v8a.*\.apk$'} | sort-object | select -Last 1); if(-not $apk){$apk=((Invoke-WebRequest -UseBasicParsing -Uri $release).Links.href | ?{$_ -match 'fenix-.*\.apk$'} | sort-object | select -Last 1)}; if($apk){$release+$apk}" || exit /b 1
call :DOWNLOAD_GITHUB_ASSET "Thunderbird" "thunderbird/thunderbird-android" ".*\.apk$" || exit /b 1
call :DOWNLOAD_GITHUB_ASSET "FlorisBoard" "florisboard/florisboard" ".*\.apk$" || exit /b 1
call :DOWNLOAD_GITHUB_ASSET "Breezy Weather" "breezy-weather/breezy-weather" "/breezy-weather-.*_standard\.apk$" || exit /b 1
call :DOWNLOAD_GITHUB_ASSET "Obtainium" "ImranR98/Obtainium" "/app-release\.apk$" || exit /b 1
call :DOWNLOAD_FROM_POWERSHELL "OSMAnd" "$base='https://download.osmand.net/releases/'; $apk=((Invoke-WebRequest -UseBasicParsing -Uri $base).Links.href | ?{$_ -match 'OsmAnd.*\.apk$'} | sort-object | select -Last 1); if($apk){$base+$apk}" || exit /b 1
call :DOWNLOAD_FROM_POWERSHELL "Aurora Store" "$json=Invoke-WebRequest -UseBasicParsing -Uri 'https://auroraoss.com/api/files' | Select-Object -ExpandProperty Content; $urls=[regex]::Matches($json,'https?://[^\" ]*AuroraStore[^\" ]*\.apk') | %%{$_.Value}; $url=$urls | Sort-Object | Select-Object -Last 1; if($url){$url}" || exit /b 1

goto check

:DOWNLOAD_GITHUB_ASSET
set "APP_NAME=%~1"
set "REPO=%~2"
set "PATTERN=%~3"
set "PS_CMD=$r=Invoke-RestMethod -Uri 'https://api.github.com/repos/%REPO%/releases/latest'; $u=$r.assets.browser_download_url | ? { $_ -match '%PATTERN%' } | Select-Object -First 1; if($u){$u}"
call :DOWNLOAD_FROM_POWERSHELL "%APP_NAME%" "%PS_CMD%"
exit /b %ERRORLEVEL%

:DOWNLOAD_FROM_POWERSHELL
set "APP_NAME=%~1"
set "PS_CODE=%~2"
set "APP_URL="
set "APP_FILE="

for /f "usebackq delims=" %%U in (`powershell -NoProfile -Command "%PS_CODE%"`) do set "APP_URL=%%U"
if not defined APP_URL (
  echo Failed to resolve latest APK for %APP_NAME%.
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
echo Install starting...
echo.
call :INSTALL_APP "F-Droid"
call :INSTALL_APP "Firefox"
call :INSTALL_APP "Thunderbird"
call :INSTALL_APP "FlorisBoard"
call :INSTALL_APP "Breezy Weather"
call :INSTALL_APP "Obtainium"
call :INSTALL_APP "OSMAnd"
call :INSTALL_APP "Aurora Store"
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
