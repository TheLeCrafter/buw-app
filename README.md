# Bundesumweltwettbewerb APP
[![Build and Test](https://github.com/TheLeCrafter/buw-app/actions/workflows/dart.yml/badge.svg?branch=master)](https://github.com/TheLeCrafter/buw-app/actions/workflows/dart.yml)

Bundesumweltwettbewerb APP by TheLeCrafter

## Getting Started

This is a German app made by TheLeCrafter for the Bundesumweltwettbewerb to show ways on how to prevent the use of plastic.

## Building
Install the latest Dart and Flutter version and clone this repository. If you want to disable hot reload on the connected device add the ``--release`` flag to the command.

### For iOS UNSUPPORTED
Run ``flutter build ios --no-codesign``. The built file is found at <project_home>/build/ios/iphoneos/Runner.app

### For Android
Run ``flutter build appbundle``. The built file is found at <project_home>/build/app/outputs/bundle/release/app-release.aab

### For Android [APK]
Run ``flutter build apk``. The built file is found at <project_home>/build/app/outputs/apk/release/app-release.apk


### Supported version
You can find the supported versions in the [SECURITY.md](https://github.com/TheLeCrafter/buw-app/blob/master/SECURITY.md)
