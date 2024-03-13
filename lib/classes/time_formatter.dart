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

import 'package:flutter/foundation.dart';

import 'calculator.dart';

class TimeFormatter extends Calculator {
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

  @override
  String getMinutes() {
    String minutesExtracted = extract();
    String minutes = '';

    for (int index = 0; index < 2; index++) {
      minutes += minutesExtracted[index];
    }

    if (kDebugMode) {
      print('[TimeFormatter::getMinutes::minutes] $minutes');
    }

    return minutes;
  }
}
