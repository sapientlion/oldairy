import 'package:oldairy/classes/locale.dart';

class Settings {
  bool isOldStandardEnabled = false;
  String currentLocale = 'English (US)';
  OldairyLocale locale = OldairyLocale();

  Settings({
    this.isOldStandardEnabled = false,
    this.currentLocale = 'English (US)',
  });
}
