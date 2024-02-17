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

//
//  ignore_for_file: prefer_conditional_assignment
//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:oldairy/classes/locale.dart';
import 'package:path_provider/path_provider.dart';

class Settings {
  bool oldStandardFlag = false; // Old standard support flag.
  bool timePrecisionFlag = false; // Precision flag.
  bool timeRoundingFlag = false; // Time rounding flag.

  double coolingCoefficientLowerLimit = 0.0;
  double coolingCoefficientUpperLimit = 0.0;
  double coolingCoefficientCurrent = 0.350;

  String packageVersion = '';
  String localeCurrent = 'English (US)';
  String localeName = '';
  OldairyLocale locale = OldairyLocale();

  //
  // Load default values from file and use them in various processes.
  //
  Future<void> readDefaults() async {
    final String response = await rootBundle.loadString('assets/defaults.json');
    final data = await json.decode(response);
    final RegExp packageVersionRegEx = RegExp(r'^([0-99]\.[0-99]\.[0-99])$');

    double? coolingCoefficientLowerLimitRaw = 0.0;
    double? coolingCoefficientUpperLimitRaw = 0.0;

    packageVersion = data['packageVersion'];

    //
    // Package version must have the following structure: <major_release>.<minor_release>.<patch>.
    //
    if (!packageVersionRegEx.hasMatch(packageVersion)) {
      packageVersion = 'N/a';
    }

    coolingCoefficientLowerLimitRaw = double.tryParse(data['coolingCoefficientLowerLimit']);

    if (coolingCoefficientLowerLimitRaw == null) {
      coolingCoefficientLowerLimit = 0.2;
    } else {
      coolingCoefficientLowerLimit = coolingCoefficientLowerLimitRaw;
    }

    coolingCoefficientUpperLimitRaw = double.tryParse(data['coolingCoefficientUpperLimit']);

    if (coolingCoefficientUpperLimitRaw == null) {
      coolingCoefficientUpperLimit = 2.0;
    } else {
      coolingCoefficientUpperLimit = coolingCoefficientUpperLimitRaw;
    }

    return;
  }

  /*Future<void> readDefaults() async {
    final String response = await rootBundle.loadString('assets/defaults.json');
    final data = await json.decode(response);

    packageVersion = data['packageVersion'];
    coolingCoefficientLowerLimit = double.parse(data['coolingCoefficientLowerLimit']);
    coolingCoefficientUpperLimit = double.parse(data['coolingCoefficientUpperLimit']);

    return;
  }*/

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
        'isOldStandardEnabled': oldStandardFlag,
        'isTimeRoundingEnabled': timeRoundingFlag,
        'areAbsoluteValuesAllowed': timePrecisionFlag,
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
