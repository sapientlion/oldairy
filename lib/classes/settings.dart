import 'dart:convert';
import 'dart:io';

import 'package:oldairy/classes/locale.dart';
import 'package:path_provider/path_provider.dart';

class Settings {
  bool isOldStandardEnabled = false;
  String currentLocale = 'English (US)';
  String localeFile = '';
  OldairyLocale locale = OldairyLocale();

  Settings({
    this.isOldStandardEnabled = false,
    this.currentLocale = 'English (US)',
  });

  //
  // Get app data location.
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
        'isOldStandardEnabled': isOldStandardEnabled,
        'currentLocale': currentLocale,
        'localeFile': localeFile,
      };

  //
  // Write data to the file.
  //
  Future<File> write(Settings settings) async {
    final file = await _settingsFile;

    String encodedSettings = jsonEncode(settings.toJson());

    //
    // Write the file.
    //
    return file.writeAsString(encodedSettings);
  }

  //
  // Read data from the file.
  //
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
