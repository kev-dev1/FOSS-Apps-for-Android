# FOSS Apps for Android

This project provides scripts to download and install a curated list of FOSS Android apps.

## Included apps
- F-Droid
- Firefox
- Thunderbird
- FlorisBoard
- Breezy Weather
- Obtainium
- OSMAnd
- Aurora Store

## Source strategy
The scripts resolve the latest versions automatically:
- **GitHub Releases**:
  - Thunderbird
  - FlorisBoard
  - Obtainium (`app-release.apk`)
  - Breezy Weather (`breezy-weather-$VERSION_standard.apk`)
- **Vendor/Project download pages**:
  - Firefox (`https://download.cdn.mozilla.net/pub/fenix/releases/`)
  - OSMAnd (`https://download.osmand.net/releases/`)
  - Aurora Store (`https://auroraoss.com/api/files`)
- **F-Droid**:
  - F-Droid installer APK

OpenTasks was removed from the app list.

## Linux requirements
- `aria2c`
- `adb` (Android platform tools)
- `curl`, `grep`, `sort`, `sed`

## Windows requirements
- Included in `files/`:
  - `aria2c.exe`
  - `adb.exe`
- `PowerShell` (used to resolve latest APK links)

## Notes
- Linux script: `foss-android.sh`
- Windows script: `foss-android.cmd` (can also be renamed to `.bat` if you prefer)
