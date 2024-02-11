# Oldairy

![GitHub Release](https://img.shields.io/github/v/release/sapientlion/oldairy)

## :book: Overview

Oldairy is a simple calculator intended for finding out the approximate cooling time of a typical industrial-sized milk tank. The project uses the following formula for achieving desirable results: `Tcooling = (((kW x (tinitial - tset)) x Vtank) / U) / I`. Each variable means the following:

* `Tcooling` is amount of time required for a substance to reach its target temperature;
* `kW` is so-called "cooling coefficient" - total amount of energy the equipment consumes;
* `Tinitial` is initial/current temperature of a substance;
* `Tset` is target temperature;
* `Vtank` is reservoir volume;
* `U` is voltage;
* `I` is amperage (which can be further extended to `I1`, `I2` and `I3` in case of three-phase voltage electricity).

Do note that the target value will never be precise. External factors such as outside temperatures, materials and et cetera are not taken into account.

## :nut_and_bolt: Features

* A calculator with a limited number of features;
* App customization - adapt app according to your current needs.

## :iphone: System requirements

The app supports all versions of Android ranging from 8.1 to the latest one. Older versions are not supported and therefore it is not guaranteed that the app would work flawlessly on those systems.

## :hammer_and_wrench: Installation

To install the app, upload it to the Android device and tap on `oldairy-<version>.apk` package. Follow the instructions given on the screen.

## :building_construction: Building

The easiest and recommended way to build `*.apk` installation packages is via Android Studio. Open the IDE, open the project, `Build > Bundle(s) / APK(s)` and follow the instructions given on the screen.

## :framed_picture: Screenshots

<p align="center">
    <img alt="Home" src="./fastlane/metadata/android/en-US/images/phoneScreenshots/1.jpg?raw=true" width="200" />
    <img alt="Settings" src="./fastlane/metadata/android/en-US/images/phoneScreenshots/2.jpg?raw=true" width="200" />
</p>

## :coffee: Donations

You can buy me a cup of coffee at https://ko-fi.com/sapientlion.

## :scroll: License

Oldairy is released under the GNU General Public License v3. Please read LICENSE for further details regarding the license.
