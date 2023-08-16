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

	Description: the main component of the app - the calculator. It
	utilizes the following formula for achieving the desirable results:

	tcooling = (((0.685 x (tinitial - tset)) x Vtank) / U) / I.

	The included constant is used for the cow/goat milk only. In theory,
	it can be used for similar substances as well.

	It's not a precise number and it will never be like that. It is
	completely dependent on the current state of equipment and environmental
	factors such as temperature and air pressure. What is used here is the
	optimal number for such formula which was found out by pure observation
	during the series of practices in the field (milk tank service and
	maintenance).

*/

import 'dart:math';

import 'package:oldairy/classes/tformatter.dart';
import 'package:oldairy/interfaces/icalculator.dart';

class Calculator implements ICalculator {
  final int _ampsLimits = 125;
  final double _milkConstant = 0.685;
  /*int _cTimeInHours = 0;
  int _cTimeInMinutes = 0;*/
  double _coolingTime = 0.0;
  TimeFormatter _timeFormatter = TimeFormatter();

  double initialTemp = 0.0;
  double setTemp = 0.0;
  double volume = 0.0;
  double voltage = 0.0;
  double ampsFirstWire = 0.0;
  double ampsSecondWire = 0.0;
  double ampsThirdWire = 0.0;

  //bool _isMoreThanSixty = false;
  /*int _cTimeInHours = 0;
  int _cTimeInMinutes = 0;
  double _coolingTime = 0.0;
  TimeFormatter _timeFormatter = TimeFormatter();

  double initialTemp = 0.0;
  double setTemp = 0.0;
  double volume = 0.0;
  double voltage = 0.0;
  double ampsFirstWire = 0.0;
  double ampsSecondWire = 0.0;
  double ampsThirdWire = 0.0;*/

  Calculator({
    required this.initialTemp,
    required this.setTemp,
    required this.volume,
    required this.voltage,
    required this.ampsFirstWire,
    required this.ampsSecondWire,
    required this.ampsThirdWire,
  });

  /*Calculator({
    this.initialTemp = 0.0,
    this.setTemp = 0.0,
    this.volume = 0.0,
    this.voltage = 0.0,
    this.ampsFirstWire = 0.0,
    this.ampsSecondWire = 0.0,
    this.ampsThirdWire = 0.0,
  });*/

  /*@override
  double getCoolingTime() {
    return _coolingTime;
  }

  @override
  int getHours() {
    _cTimeInHours = _coolingTime.toInt();

    //
    // Trigger this to flip the 60-minute flag, if need be.
    //
    /*getMinutes();

    if (_isMoreThanSixty) {
      _coolingTimeHours += 1;
    }*/

    return _cTimeInHours;
  }

  @override
  int getMinutes() {
    bool fpFlag = false; // Floating point flag.
    String cTimeAsString = _coolingTime.toString(); // Get total cooling time.
    String cTimeMinutesAsString = ''; // Cooling time (minutes).

    //
    // Separate minutes from the total cooling time. Use the following approach for better reliability when using
    // different encodings.
    //
    for (var element in cTimeAsString.runes) {
      //
      // Start including digits until after the floating point is reached.
      //
      if (fpFlag) {
        cTimeMinutesAsString += String.fromCharCode(element);
      }

      //
      // Detect the first occurence of the floating point.
      //
      if (!fpFlag && String.fromCharCode(element) == '.') {
        fpFlag = true;
      }
    }

    _cTimeInMinutes = int.parse(cTimeMinutesAsString);

    //
    // TODO check the following segment for any errors and improve it where possible.
    //
    /*if (_coolingTimeMinutes > 59) {
      _isMoreThanSixty = true;
      _coolingTimeMinutes -= 60;
    } else {
      _isMoreThanSixty = false;
    }*/

    return _cTimeInMinutes;
  }*/

  @override
  double calculateLow(int voltage) {
    if (voltage < 220 || voltage > 230) {
      return _coolingTime = 0.0;
    }

    _coolingTime /= ampsFirstWire;

    String coolingTimeRound = _coolingTime.toStringAsFixed(2);

    _coolingTime = double.parse(coolingTimeRound);

    return _coolingTime;
  }

  @override
  double calculateHigh(int voltage) {
    if (voltage < 380 || voltage > 400) {
      return _coolingTime = 0.0;
    }

    if (ampsSecondWire > _ampsLimits) {
      return _coolingTime = 0.0;
    }

    if (ampsThirdWire > _ampsLimits) {
      return _coolingTime = 0.0;
    }

    //
    // Switch to three-phase electric power in case of higher voltages.
    //
    double combinedAmperage = ampsFirstWire + ampsSecondWire + ampsThirdWire;

    combinedAmperage = combinedAmperage / sqrt(3);

    if (combinedAmperage <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime = _coolingTime / combinedAmperage;

    String coolingTimeRound = _coolingTime.toStringAsFixed(2);

    _coolingTime = double.parse(coolingTimeRound);

    return _coolingTime;
  }

  @override
  double calculate(int voltage) {
    _coolingTime = initialTemp - setTemp;

    //
    // No point in going any further when the result will always be the same
    // and equal to 0.
    //
    if (_coolingTime <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime = _milkConstant * _coolingTime;
    _coolingTime = volume * _coolingTime;

    //
    // Division by zero is undefined.
    //
    if (voltage <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime /= voltage;

    //
    // The exact same thing can happen here.
    //
    if (ampsFirstWire <= 0 || ampsFirstWire > _ampsLimits) {
      return _coolingTime = 0.0;
    }

    //
    // In case of lower voltages.
    //
    if (voltage >= 220 && voltage <= 230) {
      return calculateLow(voltage);
    }

    //
    // In case of higher voltages.
    //
    if (voltage >= 380 && voltage <= 400) {
      return calculateHigh(voltage);
    }

    return _coolingTime = 0.0;
  }
}
