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

import 'package:flutter/foundation.dart';
import 'package:oldairy/classes/settings.dart';

abstract class Calculator {
  final int _ampsLimits = 125;
  final Settings _settings = Settings();

  double _coolingTime = 0.0;

  double coefficient = 0.0;
  double initialTemp = 0.0;
  double targetTemp = 0.0;
  double volume = 0.0;
  double voltage = 0.0;
  double ampsFirstWire = 0.0;
  double ampsSecondWire = 0.0;
  double ampsThirdWire = 0.0;

  Calculator({
    required this.initialTemp,
    required this.targetTemp,
    required this.volume,
    required this.voltage,
    required this.ampsFirstWire,
    required this.ampsSecondWire,
    required this.ampsThirdWire,
    this.coefficient = 0.350,
  });

  ///
  /// Get total cooling time.
  ///
  double get() {
    return _coolingTime;
  }

  ///
  /// Calculate normally.
  ///
  double calculateLow() {
    if (voltage < 220 || voltage > 230) {
      _coolingTime = 0.0;

      if (kDebugMode) {
        print('[Calculator::calculateLow::_coolingTime : ] $_coolingTime');
      }

      return _coolingTime;
    }

    _coolingTime /= ampsFirstWire;

    if (kDebugMode) {
      print('[Calculator::calculateLow::_coolingTime : ] $_coolingTime');
    }

    return _coolingTime;
  }

  ///
  /// Calculate using three-phase electricity system.
  ///
  double calculateHigh() {
    if (voltage < 380 || voltage > 400) {
      _coolingTime = 0.0;

      if (kDebugMode) {
        print('[Calculator::calculateHigh::_coolingTime : ] $_coolingTime');
      }

      return _coolingTime;
    }

    if (ampsSecondWire > _ampsLimits) {
      _coolingTime = 0.0;

      if (kDebugMode) {
        print('[Calculator::calculateHigh::_coolingTime : ] $_coolingTime');
      }

      return _coolingTime;
    }

    if (ampsThirdWire > _ampsLimits) {
      _coolingTime = 0.0;

      if (kDebugMode) {
        print('[Calculator::calculateHigh::_coolingTime : ] $_coolingTime');
      }

      return _coolingTime;
    }

    //
    // Switch to three-phase electric power in case of higher voltages.
    //
    double combinedAmperage = ampsFirstWire + ampsSecondWire + ampsThirdWire;

    if (kDebugMode) {
      print('[Calculator::calculateHigh::combinedAmperage : ] $combinedAmperage');
    }

    combinedAmperage = combinedAmperage / sqrt(3);

    if (kDebugMode) {
      print('[Calculator::calculateHigh::combinedAmperage : ] $combinedAmperage');
    }

    if (combinedAmperage <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime /= combinedAmperage;

    if (kDebugMode) {
      print('[Calculator::calculateHigh::_coolingTime : ] $_coolingTime');
    }

    return _coolingTime;
  }

  ///
  /// Calculate and get total cooling time.
  ///
  double calculate() {
    _coolingTime = initialTemp - targetTemp;

    if (kDebugMode) {
      print('[Calculator::calculate::_coolingTime : ] $_coolingTime');
    }

    //
    // No point in going any further when the result will always be the same
    // and equal to 0.
    //
    if (_coolingTime <= 0) {
      _coolingTime = 0.0;

      if (kDebugMode) {
        print('[Calculator::calculate::_coolingTime : ] $_coolingTime');
      }

      return _coolingTime;
    }

    if (coefficient < _settings.coolingCoefficientLowerLimit || coefficient > _settings.coolingCoefficientUpperLimit) {
      coefficient = _settings.coolingCoefficientLowerLimit;
    }

    _coolingTime = coefficient * _coolingTime;

    if (kDebugMode) {
      print('[Calculator::calculate::_coolingTime : ] $_coolingTime');
    }

    _coolingTime = volume * _coolingTime;

    if (kDebugMode) {
      print('[Calculator::calculate::_coolingTime : ] $_coolingTime');
    }

    //
    // Division by zero is undefined.
    //
    if (voltage <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime /= voltage;

    if (kDebugMode) {
      print('[Calculator::calculate::_coolingTime : ] $_coolingTime');
    }

    //
    // The exact same thing can happen here.
    //
    if (ampsFirstWire <= 0 || ampsFirstWire > _ampsLimits) {
      _coolingTime = 0.0;

      if (kDebugMode) {
        print('[Calculator::calculate::_coolingTime : ] $_coolingTime');
      }

      return _coolingTime;
    }

    //
    // In case of lower voltages.
    //
    if (voltage >= 220 && voltage <= 230) {
      return calculateLow();
    }

    //
    // In case of higher voltages.
    //
    if (voltage >= 380 && voltage <= 400) {
      return calculateHigh();
    }

    return _coolingTime = 0.0;
  }
}
