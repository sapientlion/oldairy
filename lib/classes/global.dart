import 'package:flutter/cupertino.dart';

abstract class Global {
  static const String keyCoolingCoefficientLowerLimit = 'coolingCoefficientLowerLimit';
  static const String keyCoolingCoefficientUpperLimit = 'coolingCoefficientUpperLimit';
  static const String keyCoefficientValue = 'coefficientValue';
  static const String keyLocaleCurrent = 'localeCurrent';
  static const String keyLocaleFile = 'localeFile';
  static const String keyMinutesRounding = 'minutesRounding';
  static const String keyOldStandard = 'oldStandard';
  static const String keyPackageRelease = 'packageRelease';
  static const String keyPackageVersion = 'packageVersion';
  static const String keyTimeRounding = 'timeRounding';
  static const String keyUpdateCheckOnStartup = 'updateCheckOnStartup';

  static const double defaultScrollbarThickness = 11.0;
  static const EdgeInsets defaultEdgeInsets = EdgeInsets.all(30.0);
}
