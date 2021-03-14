#!/bin/bash

# The Applications downloading in the Apps Folder.
destDir="Apps"

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
echo ""
echo "Yes to install or No for not."
read ant
echo ""
if [ "$ant" == 'Yes' ];
  then
  echo "Downloading F-Droid..."
  wget -P "$destDir" -nc https://f-droid.org/F-Droid.apk
  echo "Download complete!"
  echo ""
  echo "Downloading OSMAnd..."
  wget -P "$destDir" -nc https://f-droid.org/repo/net.osmand.plus_398.apk
  echo "Download complete!"
  echo ""
  echo "Downloading Davx5..."
  wget -P "$destDir" -nc https://f-droid.org/repo/at.bitfire.davdroid_303090004.apk
  echo "Download complete!"
  echo ""
  echo "Downloading OpenTasks..."
  wget -P "$destDir" -nc https://f-droid.org/repo/org.dmfs.tasks_80800.apk
  echo "Download complete!"
  echo ""
  echo "Downloading NewPipe..."
  wget -P "$destDir" -nc https://f-droid.org/repo/org.schabi.newpipe_965.apk
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
    if [[ "$adb" == 'Yes' ]]; then
      echo ""
      echo "Install F-Droid..."
      adb install ./Apps/F-Droid.apk
      echo "Install complete!"
      echo ""
      echo "Install OSMAnd..."
      adb install ./Apps/net.osmand.plus_398.apk
      echo "Install complete!"
      echo ""
      echo "Install Davx5..."
      adb install ./Apps/at.bitfire.davdroid_303090004.apk
      echo "Install complete!"
      echo ""
      echo "Install OpenTasks..."
      adb install ./Apps/org.dmfs.tasks_80800.apk
      echo "Install complete!"
      echo ""
      echo "Install NewPipe..."
      adb install ./Apps/org.schabi.newpipe_965.apk
      echo "Install complete!"
      echo ""
      echo "Have a Nice day with you FOSS Device!!"
      echo ""
    elif [[ "$adb" == 'No' ]]; then
      echo "Check thats you Device had ADB activated!"
      exit 1
    fi
  done
elif [ "$ant" == 'No' ]; then
  echo "Oh, Sorry for you. The FOSS Apps are good."
  exit 1
fi
