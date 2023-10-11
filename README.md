# Oldairy

Oldairy - a simple calculator for finding out the approximate cooling time of a typical industrial-sized milk tank.

## :nut_and_bolt: Features :nut_and_bolt:

* Basic cooling time calculator;
* Flexible app customization; adapt the app according to your current needs.

## :wrench: How Does It Work? :wrench:

Oldairy utilizes the following formula for achieving the desirable results:

`Tcooling = (((0.685 x (tinitial - tset)) x Vtank) / U) / I`.

Where `Tcooling` is a total cooling time of a milk tank, `Tinitial` is initial temperature of a milk tank contents, `Tset` is a desirable temperature, `Vtank` is a reservoir volume, `U` is voltage, `I` is amperage.

The included constant (0.685) is used for the cow milk only. In theory, it can be used for similar substances as well.

It's not a precise number and it will never be like that. It is completely dependent on the current state of equipment and environmental factors such as temperature and air pressure. What is used here is the optimal number for such formula which was found out by pure observation during the practice in the field (i.e. milk tank service and maintenance).

## :iphone: System requirements :iphone:

* Android 10 and higher.

## :hammer_and_wrench: Installation :hammer_and_wrench:

To install the app, upload it to Android device and tap on `oldairy-<version>.apk` installation package. Follow the instructions given on the screen.

## :building_construction: Building :building_construction:

The easiest and recommended way to build `*.apk` installation packages is via Android Studio. Open the editor, open the project, `Build > Bundle(s) / APK(s)` and follow the instructions given on the screen.

## :framed_picture: Screenshots :framed_picture:

<p float="left">
    <img alt="Home" src="./fastlane/metadata/android/en-US/images/phoneScreenshots/1.jpg?raw=true" width="200" />
    <img alt="Settings" src="./fastlane/metadata/android/en-US/images/phoneScreenshots/2.jpg?raw=true" width="200" />
</p>

## :coffee: A Cup of Coffee & Stuff :coffee:

You can buy me a cup of coffee at https://ko-fi.com/sapientlion.

## :scroll: License :scroll:

Oldairy is released under the GNU General Public License v3. Please read LICENSE for further details regarding the license.
