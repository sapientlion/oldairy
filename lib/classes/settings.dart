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

import 'package:oldairy/classes/locale.dart';
import 'package:oldairy/interfaces/isettings.dart';
import 'package:path_provider/path_provider.dart';

class Settings implements ISettings {
  bool osFlag = false; // Old standard support flag.
  bool avFlag = true; // Absolute values flag.
  bool trFlag = true; // Time rounding flag.
  String currentLocale = 'English (US)';
  String localeName = '';
  OldairyLocale locale = OldairyLocale();

  Settings({
    this.osFlag = false,
    this.avFlag = true,
    this.trFlag = true,
    this.currentLocale = 'English (US)',
  });

  /*Settings({
    this.osFlag = false,
    this.currentLocale = 'English (US)',
  });*/

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

  //
  // Convert class members to JSON attributes.
  //
  @override
  Map<String, dynamic> toJson() => {
        'isOldStandardEnabled': osFlag,
        'isTimeRoundingEnabled': trFlag,
        'areAbsoluteValuesAllowed': avFlag,
        'currentLocale': currentLocale,
        'localeFile': localeName,
      };

  /*Map<String, dynamic> toJson() => {
        'isOldStandardEnabled': osFlag,
        'currentLocale': currentLocale,
        'localeFile': localeName,
      };*/

  @override
  Future<File> write(Settings settings) async {
    final file = await _settingsFile;

    String encodedSettings = jsonEncode(settings.toJson());

    //
    // Write the file.
    //
    return file.writeAsString(encodedSettings);
  }

  @override
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
