#!/bin/bash

# The Applications downloading in the Apps Folder.
destDir="Apps"

echo ""
echo "###############################################################"
echo "                 Kev-Dev1 script Project"
echo ""
echo " You can help me with my Project"
echo " When you have a Idea or you find a Bug, please create a"
echo " Issues on Github to this Project."
echo ""
echo " Github: https://github.com/kev-dev1"
echo ""
echo "################################################################"
echo ""
echo "This is a little script for my Favorites FOSS Apps for Android."
echo "This is a alternativ for GApps too."
echo ""
echo "You can uninstall the unnecessary if you want!"
echo ""
echo "Do you want to install these Applications"
echo "F-Droid"
echo "OSMAnd"
echo "Davx5"
echo "OpenTasks"
echo "NewPipe"
echo "FlorisBoard"
echo ""
echo "[Y] to install, [N] for not or [E] for exit."
read ant
echo ""
if [ "$ant" == 'Y']; then
  echo "Downloading F-Droid..."
  aria2c -d "$destDir" --no-conf --allow-overwrite=true https://f-droid.org/F-Droid.apk
  echo "Download complete!"
  echo ""
  echo "Downloading OSMAnd..."
  aria2c -d "$destDir" --no-conf --allow-overwrite=true https://f-droid.org/repo/net.osmand.plus_400.apk
  echo "Download complete!"
  echo ""
  echo "Downloading Davx5..."
  aria2c -d "$destDir" --no-conf --allow-overwrite=true https://f-droid.org/repo/at.bitfire.davdroid_303110004.apk
  echo "Download complete!"
  echo ""
  echo "Downloading OpenTasks..."
  aria2c -d "$destDir" --no-conf --allow-overwrite=true https://f-droid.org/repo/org.dmfs.tasks_82200.apk
  echo "Download complete!"
  echo ""
  echo "Downloading NewPipe..."
  aria2c -d "$destDir" --no-conf --allow-overwrite=true https://f-droid.org/repo/org.schabi.newpipe_971.apk
  echo "Download complete!"
  echo ""
  echo "Downloading FlorisBoard..."
  aria2c -d "$destDir" --no-conf --allow-overwrite=true https://f-droid.org/repo/dev.patrickgold.florisboard_43.apk
  echo "Download complete!"
  echo ""
  while true;
  do
    echo "See you Android Device in the List"
    adb devices
    echo "When Yes but they see unauthorized."
    echo "Authorized this on you Device!"
    echo ""
    read adb
    if [[ "$adb" == 'Y' ]]; then
      echo ""
      echo "Install F-Droid..."
      adb install ./Apps/F-Droid.apk
      echo "Install complete!"
      echo ""
      echo "Install OSMAnd..."
      adb install ./Apps/net.osmand.plus_400.apk
      echo "Install complete!"
      echo ""
      echo "Install Davx5..."
      adb install ./Apps/at.bitfire.davdroid_303110004.apk
      echo "Install complete!"
      echo ""
      echo "Install OpenTasks..."
      adb install ./Apps/org.dmfs.tasks_82200.apk
      echo "Install complete!"
      echo ""
      echo "Install NewPipe..."
      adb install ./Apps/org.schabi.newpipe_971.apk
      echo "Install complete!"
      echo ""
      echo "Install FlorisBoard..."
      adb install ./Apps/dev.patrickgold.florisboard_43.apk
      echo "Install complete!"
      echo ""
      echo "Have a Nice day with you FOSS Device!!"
      echo ""
    elif [[ "$adb" == 'N']]; then
      echo "Check thats you Device had ADB activated!"
      exit 1
    fi
  done
elif [ "$ant" == 'N']; then
  echo "Oh, Sorry for you. The FOSS Apps are good."
  exit 1
elif [[ "$ant" == 'E' ]]; then
  exit
else
  echo "Please Type again"
fi
