#!/bin/bash

set -euo pipefail

# The Applications downloading in the Apps Folder.
destDir="Apps"
mkdir -p "$destDir"

declare -A APK_FILES

# package id => display name
declare -A APPS=(
  [net.osmand.plus]="OSMAnd"
  [at.bitfire.davdroid]="Davx5"
  [org.dmfs.tasks]="OpenTasks"
  [org.schabi.newpipe]="NewPipe"
  [dev.patrickgold.florisboard]="FlorisBoard"
)

get_latest_fdroid_apk_url() {
  local package_id="$1"
  local page_url="https://f-droid.org/packages/${package_id}/"

  curl -fsSL "$page_url" \
    | grep -oE 'https://f-droid.org/repo/[^" ]+\.apk' \
    | head -n 1
}

download_and_store() {
  local display_name="$1"
  local url="$2"

  echo "Downloading ${display_name}..."
  aria2c -d "$destDir" --no-conf --allow-overwrite=true --file-allocation=none "$url"

  local downloaded_file
  downloaded_file="$(basename "${url%%\?*}")"
  APK_FILES["$display_name"]="$downloaded_file"

  echo "Download complete: $downloaded_file"
  echo ""
}

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
read -r ant
echo ""

if [[ "$ant" == 'Y' || "$ant" == 'y' ]]; then
  download_and_store "F-Droid" "https://f-droid.org/F-Droid.apk"

  for package_id in "${!APPS[@]}"; do
    app_name="${APPS[$package_id]}"
    apk_url="$(get_latest_fdroid_apk_url "$package_id")"

    if [[ -z "$apk_url" ]]; then
      echo "Could not find latest APK URL for $app_name ($package_id)."
      exit 1
    fi

    download_and_store "$app_name" "$apk_url"
  done

  while true; do
    echo "See your Android Device in the List"
    adb devices
    echo "When Yes but they see unauthorized."
    echo "Authorize this on your Device!"
    echo ""
    read -r adb_answer

    if [[ "$adb_answer" == 'Y' || "$adb_answer" == 'y' ]]; then
      for app in "F-Droid" "OSMAnd" "Davx5" "OpenTasks" "NewPipe" "FlorisBoard"; do
        echo "Install $app..."
        adb install "./$destDir/${APK_FILES[$app]}"
        echo "Install complete!"
        echo ""
      done

      echo "Have a Nice day with your FOSS Device!!"
      echo ""
      break
    elif [[ "$adb_answer" == 'N' || "$adb_answer" == 'n' ]]; then
      echo "Check that your Device has ADB activated!"
      exit 1
    fi
  done
elif [[ "$ant" == 'N' || "$ant" == 'n' ]]; then
  echo "Oh, Sorry for you. The FOSS Apps are good."
  exit 1
elif [[ "$ant" == 'E' || "$ant" == 'e' ]]; then
  exit 0
else
  echo "Please Type again"
  exit 1
fi
