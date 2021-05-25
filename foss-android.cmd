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
echo "Telegram Messenger"
echo.
echo Type [Y] to install, [N] for not or [E] for exit
echo Or type Exit to close this script!
echo.
set /p enter= "Choose: "
if %enter% == Y goto download
if %enter% == y goto download
if %enter% == N goto exit
if %enter% == n goto exit
if %enter% == E goto EOF
if %enter% == e goto EOF
echo.
echo Please type correct!
echo.
pause
goto main

:download
cls

:START_PROCESS
set "aria2c=files\aria2c.exe"
set "adb=files\adb.exe"
set "destDir=Apps"

if NOT EXIST %aria2c% goto :NO_ARIA2
if NOT EXIST %adb% goto :NO_ADB

echo.
echo Download starts...
echo.
cls
echo Downloading F-Droid...
%aria2c% -d %destDir% --no-conf --allow-overwrite=true --file-allocation=none https://f-droid.org/F-Droid.apk
if %ERRORLEVEL% GTR 0 call :DOWNLOAD_ERROR & exit /b 1
echo "Download complete!"
echo.
cls
echo Downloading OSMAnd...
%aria2c% -d %destDir% --no-conf --allow-overwrite=true --file-allocation=none https://f-droid.org/repo/net.osmand.plus_400.apk
if %ERRORLEVEL% GTR 0 call :DOWNLOAD_ERROR & exit /b 1
echo Download complete!
echo.
cls
echo Downloading Davx5...
%aria2c% -d %destDir% --no-conf --allow-overwrite=true --file-allocation=none https://f-droid.org/repo/at.bitfire.davdroid_303100003.apk
if %ERRORLEVEL% GTR 0 call :DOWNLOAD_ERROR & exit /b 1
echo Download complete!
echo.
cls
echo Downloading OpenTasks...
%aria2c% -d %destDir% --no-conf --allow-overwrite=true --file-allocation=none https://f-droid.org/repo/org.dmfs.tasks_82200.apk
if %ERRORLEVEL% GTR 0 call :DOWNLOAD_ERROR & exit /b 1
echo Download complete!
echo.
cls
echo Downloading NewPipe...
%aria2c% -d %destDir% --no-conf --allow-overwrite=true --file-allocation=none https://f-droid.org/repo/org.schabi.newpipe_968.apk
echo.
cls
echo Downloading FlorisBoard...
%aria2c% -d %destDir% --no-conf --allow-overwrite=true --file-allocation=none https://f-droid.org/repo/dev.patrickgold.florisboard_43.apk
echo.
cls
echo Downloading Telegram Messenger...
%aria2c% -d %destDir% --no-conf --allow-overwrite=true --file-allocation=none https://f-droid.org/repo/org.telegram.messenger_22935.apk
if %ERRORLEVEL% GTR 0 call :DOWNLOAD_ERROR & exit /b 1
echo Download complete!
echo.
pause
goto check

:check
cls
echo.
echo Check on your Android Device is ADB-Debugging active.
echo.
%adb% device
echo.
echo Is you Android Device in the list?
echo [Y]es or [N]o
set /p adb =
if %adb% == Y goto install
if %adb% == y goto install
if %adb% == N goto check_ERROR
if %adb% == n goto check_ERROR


:install
cls
echo.
echo Install starting...
echo.
cls
echo "Install F-Droid..."
%adb% install %destDir%\F-Droid.apk
echo "Install complete!"
echo.
cls
echo "Install OSMAnd..."
%adb% install %destDir%\net.osmand.plus_400.apk
echo "Install complete!"
echo.
cls
echo "Install Davx5..."
%adb% install %destDir%\at.bitfire.davdroid_303100003.apk
echo "Install complete!"
echo.
cls
echo "Install OpenTasks..."
%adb% install %destDir%\org.dmfs.tasks_82200.apk
echo "Install complete!"
echo.
cls
echo "Install NewPipe..."
%adb% install %destDir%\org.schabi.newpipe_968.apk
echo "Install complete!"
echo.
cls
echo "Install FlorisBoard..."
%adb% install %destDir%\dev.patrickgold.florisboard_43.apk
echo "Install complete!"
cls
echo "Install Telegram Messenger..."
%adb% install %destDir%\org.telegram.messenger_22935.apk
echo "Install complete!"
goto finish

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
echo Have a Nice day with you Android FOSS Device!!
echo.
pause
exit

:check_ERROR
cls
echo.
echo Please check thats your Android Devices had ADB-Debugging active.
echo.
pause
goto check

:DOWNLOAD_ERROR
echo.
echo Error on downloading the Files.
echo Please check you Internet connecting or try this later.
echo.
pause
goto EOF

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
echo Please check in the Files folder the file adb.exe exists.
echo When not than download the Script again.
echo.
pause
exit

:EOF
