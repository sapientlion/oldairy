/*

    Oldairy - a simple calculator for finding out the approximate
	  cooling time of a typical industrial-sized milk tank.
    Copyright (C) 2023  Leo "SapientLion" Markoff

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

	  Description: manage app settings via flags and data.

*/

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:oldairy/classes/locale.dart';
import 'package:path_provider/path_provider.dart';

class Settings {
  bool osFlag = false; // Old standard support flag.
  bool pFlag = false; // Precision flag.
  bool rFlag = false; // Time rounding flag.

  double coolingCoefficientLowerLimit = 0.0;
  double coolingCoefficientUpperLimit = 0.0;
  double coolingCoefficientCurrent = 0.350;

  String packageVersion = '';
  String localeCurrent = 'English (US)';
  String localeName = '';
  OldairyLocale locale = OldairyLocale();

  Future<void> readDefaults() async {
    final String response = await rootBundle.loadString('assets/defaults.json');
    final data = await json.decode(response);

    packageVersion = data['packageVersion'];
    coolingCoefficientLowerLimit = double.parse(data['coolingCoefficientLowerLimit']);
    coolingCoefficientUpperLimit = double.parse(data['coolingCoefficientUpperLimit']);

    return;
  }

  Settings() {
    readDefaults();
  }

  //
  // Get app data location path.
  //
  Future<String> get _appDataPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  //
  // Get a settings file.
  //
  Future<File> get _settingsFile async {
    final path = await _appDataPath;
    return File('$path/settings.json');
  }

  Map<String, dynamic> toJson() => {
        'isOldStandardEnabled': osFlag,
        'isTimeRoundingEnabled': rFlag,
        'areAbsoluteValuesAllowed': pFlag,
        'coefficient': coolingCoefficientCurrent,
        'currentLocale': localeCurrent,
        'localeFile': localeName,
      };

  Future<File> write(Settings settings) async {
    final file = await _settingsFile;

    String encodedSettings = jsonEncode(settings.toJson());

    //
    // Write the file.
    //
    return file.writeAsString(encodedSettings);
  }

  Future<String> read() async {
    try {
      final file = await _settingsFile;

      //
      // Read the file.
      //
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }
}
