#!/bin/bash

set -euo pipefail

destDir="Apps"
mkdir -p "$destDir"

declare -A APK_FILES
APPS_TO_INSTALL=("F-Droid" "Firefox" "Thunderbird" "FlorisBoard" "Breezy Weather" "Obtainium" "OSMAnd" "Aurora Store")

fetch_text() {
  curl -fsSL "$1"
}

get_latest_from_index() {
  local url="$1"
  local regex="$2"
  fetch_text "$url" \
    | grep -oE "$regex" \
    | sort -uV \
    | tail -n 1
}

get_latest_github_asset_url() {
  local repo="$1"
  local asset_regex="$2"

  fetch_text "https://api.github.com/repos/${repo}/releases/latest" \
    | grep -oE '"browser_download_url"[[:space:]]*:[[:space:]]*"[^"]+"' \
    | sed -E 's/^"browser_download_url"[[:space:]]*:[[:space:]]*"(.*)"$/\1/' \
    | grep -E "$asset_regex" \
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

resolve_firefox_url() {
  local base="https://download.cdn.mozilla.net/pub/fenix/releases/"
  local release_dir
  release_dir="$(get_latest_from_index "$base" 'v[0-9]+\.[0-9]+\.[0-9]+/')"
  local release_url="${base}${release_dir}"

  local apk_name
  apk_name="$(get_latest_from_index "$release_url" 'fenix-[^" ]*arm64-v8a[^" ]*\.apk')"
  if [[ -z "$apk_name" ]]; then
    apk_name="$(get_latest_from_index "$release_url" 'fenix-[^" ]*\.apk')"
  fi

  echo "${release_url}${apk_name}"
}

resolve_osmand_url() {
  local base="https://download.osmand.net/releases/"
  local apk_name
  apk_name="$(get_latest_from_index "$base" 'OsmAnd[^" ]*\.apk')"
  echo "${base}${apk_name}"
}

resolve_aurora_store_url() {
  fetch_text "https://auroraoss.com/api/files" \
    | grep -oE 'https?://[^" ]*AuroraStore[^" ]*\.apk' \
    | sort -uV \
    | tail -n 1
}

print_header() {
  echo ""
  echo "###############################################################"
  echo "                 Kev-Dev1 script Project"
  echo ""
  echo " Github: https://github.com/kev-dev1"
  echo ""
  echo "################################################################"
  echo ""
  echo "This script downloads and installs these Apps:"
  for app in "${APPS_TO_INSTALL[@]}"; do
    echo "$app"
  done
  echo ""
  echo "[Y] to install, [N] for not or [E] for exit."
}

print_header
read -r ant
echo ""

if [[ "$ant" == 'Y' || "$ant" == 'y' ]]; then
  download_and_store "F-Droid" "https://f-droid.org/F-Droid.apk"
  download_and_store "Firefox" "$(resolve_firefox_url)"
  download_and_store "Thunderbird" "$(get_latest_github_asset_url 'thunderbird/thunderbird-android' '.*\.apk$')"
  download_and_store "FlorisBoard" "$(get_latest_github_asset_url 'florisboard/florisboard' '.*\.apk$')"
  download_and_store "Breezy Weather" "$(get_latest_github_asset_url 'breezy-weather/breezy-weather' '.*/breezy-weather-.*_standard\.apk$')"
  download_and_store "Obtainium" "$(get_latest_github_asset_url 'ImranR98/Obtainium' '.*/app-release\.apk$')"
  download_and_store "OSMAnd" "$(resolve_osmand_url)"
  download_and_store "Aurora Store" "$(resolve_aurora_store_url)"

  while true; do
    echo "See your Android Device in the List"
    adb devices
    echo "Authorize this on your Device if needed."
    echo ""
    read -r adb_answer

    if [[ "$adb_answer" == 'Y' || "$adb_answer" == 'y' ]]; then
      for app in "${APPS_TO_INSTALL[@]}"; do
        echo "Install $app..."
        adb install "./$destDir/${APK_FILES[$app]}"
        echo "Install complete!"
        echo ""
      done
      echo "Have a nice day with your FOSS Device!!"
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
