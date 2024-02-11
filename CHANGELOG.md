Oldairy 1.0.0 - Released on August 8th, 2023.

Added:

* A cooling time calculator;
* A support for older IEC standard voltages (220V/380V).

Changed:

* N/a.

Fixed:

* N/a.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Oldairy 1.0.1 - Released on September 11th, 2023.

Added:

* Three new settings on the `Settings` page which allow more control over calculations;
* `TimeFormatter` class which can be used for extracting hours and minutes from raw cooling time value.

Changed:

* Time rounding feature which was previously disabled due to inadequacy of the previous implementation;
* Any kind of time formatting from `Calculator` class;
* Flutter version: from `3.3.5` to `3.10.6`;
* Gradle version: from `7.4.0` to `7.6.2`.

Fixed:

* A critical bug that caused cooling time to be completely imprecise upon a calculation due to missing hour reset routine.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Oldairy 1.0.2 - Released on October 12th, 2023.

Added:

* A visible scrollbar on all pages.

Changed:

* Font appearance on some pages;
* On `Settings` page, stick action buttons to the bottom of the screen instead of leaving them at the bottom of the page;
* Optimized the source code for better maintainability and scalability.

Fixed:

* Font sizes on all pages.
* A bug that caused app to crash due to the missing voltage values when switching back from the older standard to the newest one.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Oldairy 1.0.3 - Released on October 18th, 2023.

Added:

* N/a.

Changed:

* The minimal supported version of Android: from `10` to `8.1`.

Fixed:

* An issue where a git submodule was pointing to the incorrect version of Flutter.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Oldairy 1.0.4 - Released on February 12th, 2024.

Added:

* N/a.

Changed:

* Background and foreground colors of the bottom bar on the `Settings` page;
* Cooling coefficient lower limit: from `0.685` down to `0.2`;
* Maximum number of character inside of input fields: remove this from all affected widgets. Rely on other methods of filtering values;
* Overall performance of the app: removed unnecessary interfaces, duplicate code and et cetera;
* `package_info_plus`: remove dependency and use app's data file instead for fetching package info;
* Text alignment inside and outside of the dropdown menus;
* The way the app settings are applied: refuse to save app settings if cooling coefficient value has either exceed or underceeded the limits. Show an alert box on `Apply` button press;
* The way the input fields behave: when no longer needed, hide them using `Visibility` widget instead of changing their opacity.

Fixed:

* Inability to change cooling coefficient value due to the awkwardly implemented validation check;
* Minor typo on the `Settings` page.
