# FOSS Apps for Android

This project provides scripts to download and install a curated list of FOSS Android apps.

## What changed
The scripts now resolve the **latest available APK versions automatically** from F-Droid at runtime.
You no longer need to manually update hardcoded version numbers in filenames.

## Included apps
- F-Droid
- OSMAnd
- Davx5
- OpenTasks
- NewPipe
- FlorisBoard

## Linux requirements
- `aria2c`
- `adb` (Android platform tools)
- `curl`, `grep` (used to resolve latest APK links)

## Windows requirements
- Included in `files/`:
  - `aria2c.exe`
  - `adb.exe`
- `PowerShell` (already available on modern Windows versions, used to resolve latest APK links)

## Notes
- Linux script: `foss-android.sh`
- Windows script: `foss-android.cmd` (can also be renamed to `.bat` if you prefer)
