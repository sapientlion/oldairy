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
import 'package:http/http.dart' as http;

class Settings {
  bool oldStandardFlag = false;
  bool timePrecisionFlag = false;
  bool timeRoundingFlag = false;
  bool updateCheckFlag = false;

  double coolingCoefficientLowerLimit = 0.0;
  double coolingCoefficientUpperLimit = 0.0;
  double coolingCoefficientCurrent = 0.0;

  String packageRelease = '';
  String packageVersion = '';
  String localeCurrent = 'English (US)';
  String localeName = '';
  OldairyLocale locale = OldairyLocale();

  dynamic responseBody;

  //
  // Load default values from file and use them later in various processes.
  //
  Future<void> _readDefaults() async {
    final String response = await rootBundle.loadString('assets/defaults.json');
    final data = await json.decode(response);
    final RegExp packageVersionRegEx = RegExp(r'^([0-99]\.[0-99]\.[0-99])$');

    bool? oldStandardFlagRaw = false;
    bool? timePrecisionFlagRaw = false;
    bool? timeRoundingFlagRaw = false;
    bool? updateCheckRaw = false;
    double? coolingCoefficientLowerLimitRaw = 0.0;
    double? coolingCoefficientUpperLimitRaw = 0.0;

    packageRelease = data['packageRelease'];

    if (packageRelease == '') {
      packageRelease = 'https://api.github.com/repos/sapientlion/oldairy/releases/latest';
    }

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
      coolingCoefficientCurrent = coolingCoefficientLowerLimit = coolingCoefficientLowerLimitRaw;
    }

    coolingCoefficientUpperLimitRaw = double.tryParse(data['coolingCoefficientUpperLimit']);

    if (coolingCoefficientUpperLimitRaw == null) {
      coolingCoefficientUpperLimit = 2.0;
    } else {
      coolingCoefficientUpperLimit = coolingCoefficientUpperLimitRaw;
    }

    updateCheckRaw = bool.tryParse(data['updateCheckOnStartup']);

    if (updateCheckRaw == null) {
      updateCheckFlag = false;
    } else {
      updateCheckFlag = oldStandardFlagRaw;
    }

    oldStandardFlagRaw = bool.tryParse(data['oldStandard']);

    if (oldStandardFlagRaw == null) {
      oldStandardFlag = false;
    } else {
      oldStandardFlag = oldStandardFlagRaw;
    }

    timePrecisionFlagRaw = bool.tryParse(data['timePrecision']);

    if (timePrecisionFlagRaw == null) {
      timePrecisionFlag = true;
    } else {
      timePrecisionFlag = timePrecisionFlagRaw;
    }

    timeRoundingFlagRaw = bool.tryParse(data['timeRounding']);

    if (timeRoundingFlagRaw == null) {
      timeRoundingFlag = true;
    } else {
      timeRoundingFlag = timeRoundingFlagRaw;
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
    _readDefaults();
  }

  //
  // Check for any updates.
  //
  dynamic checkUpdate() async {
    final Uri uri = Uri.parse(packageRelease);
    final Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    /*http.Response response = await http.get(
      uri,
      headers: header,
    );*/

    /*if (response.statusCode == 200) {
      result = json.decode(response.body);

      if (_settings.packageVersion != result['tag_name']) {
        newUpdate = true;
      } else {
        newUpdate = false;
      }
    } else {
      newUpdate = false;
    }*/

    http.Response response = await http.get(
      uri,
      headers: header,
    );

    if (response.statusCode == 200) {
      return responseBody = json.decode(response.body);
    }

    return responseBody = '';
    //return response;
  }

  //
  // Reset values to default ones for every class member.
  //
  void reset() {
    _readDefaults();

    coolingCoefficientCurrent = coolingCoefficientLowerLimit;

    return;
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
        'updateCheckOnStartup': updateCheckFlag,
      };

  Future<File> write(Settings settings) async {
    final file = await _settingsFile;

    String encodedSettings = jsonEncode(settings.toJson());

    //
    // Write data to file.
    //
    return file.writeAsString(encodedSettings);
  }

  Future<String> read() async {
    try {
      final file = await _settingsFile;

      //
      // Read data from file.
      //
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }
}
