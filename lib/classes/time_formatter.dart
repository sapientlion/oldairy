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

	  Description: time formatter class.

*/

import 'calculator.dart';

class TimeFormatter extends Calculator {
  final int _minutesInOneHour = 60;

  int _cTimeHours = 0;
  int _cTimeMinutes = 0;
  double _cTime = 0.0;

  TimeFormatter({
    required super.initialTemp,
    required super.targetTemp,
    required super.volume,
    required super.voltage,
    required super.ampsFirstWire,
    required super.ampsSecondWire,
    required super.ampsThirdWire,
    super.coefficient = 0.350,
  });

  int getFraction(String value) {
    if (value.isEmpty) {
      return 0;
    }

    bool dpFlag = false; // Decimal point flag.
    String resValue = '';

    for (var element in value.runes) {
      //
      // Start including digits until after the floating point is reached.
      //
      if (dpFlag) {
        resValue += String.fromCharCode(element);
      }

      //
      // Detect the first occurence of the floating point.
      //
      if (!dpFlag && String.fromCharCode(element) == '.') {
        dpFlag = true;
      }
    }

    return int.parse(resValue);
  }

  int getHours() {
    _cTime = super.get();

    return _cTimeHours = _cTime.toInt();
  }

  int getMinutes({
    bool rFlag = true, // Time rounding flag.
    bool pFlag = true, // Precision flag.
  }) {
    _cTime = super.get();

    if (_cTime <= 0) {
      return _cTimeMinutes;
    }

    if (!rFlag) {
      return _cTimeMinutes = getFraction(_cTime.toStringAsFixed(2).toString());
    }

    double minutes = _cTime - _cTime.toInt();
    double seconds = 0.0;

    minutes *= _minutesInOneHour;
    seconds = minutes - minutes.toInt();

    //
    // Use a precision flag; force minutes to be more precise.
    //
    if (pFlag && seconds >= 0.5) {
      minutes++;
    }

    return _cTimeMinutes = minutes.toInt();
  }
}
