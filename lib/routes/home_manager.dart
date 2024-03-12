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

    Description: the home route.

*/

import 'package:flutter/cupertino.dart';
import 'package:oldairy/classes/calculator.dart';
import 'package:oldairy/classes/settings.dart';
import 'package:oldairy/classes/time_formatter.dart';
import 'package:oldairy/routes/home.dart';

abstract class HomeRouteStateManager extends State<HomeRoute> {
  final int _initTempLimit = 50;
  final int _volumeLimit = 30000;
  final int _ampsLimit = 125;
  final double _targetTempLimit = -273.15;
  final double _absoluteZero = -273.15;

  @protected
  final double initialValue = 0.0;
  @protected
  final String temperatureOutputInitValue = 'N/a';

  @protected
  bool absoluteZeroFlag = false;
  @protected
  bool phaseAvailabilityFlag = false; // Three-phase electricity switch.
  @protected
  int dropdownValue = 0; // Current dropdown button value.
  @protected
  String coolingTimeHours = '0'; // Cooling time: hours.
  @protected
  String coolingTimeMinutes = '0'; // Cooling time: minutes.
  @protected
  Settings settings = Settings(); // General app settings.

  @protected
  TimeFormatter timeFormatter = TimeFormatter(
    initialTemp: 0.0,
    targetTemp: 0.0,
    volume: 0.0,
    voltage: 0.0,
    ampsFirstWire: 0.0,
    ampsSecondWire: 0.0,
    ampsThirdWire: 0.0,
  );

  @protected
  TextEditingController temperatureOutputCtrl = TextEditingController();
  @protected
  TextEditingController volumeCtrl = TextEditingController();
  @protected
  TextEditingController ampsFirstWireCtrl = TextEditingController();
  @protected
  TextEditingController ampsSecondWireCtrl = TextEditingController();
  @protected
  TextEditingController ampsThirdWireCtrl = TextEditingController();
  @protected
  TextEditingController initTempCtrl = TextEditingController();
  @protected
  TextEditingController targetTempCtrl = TextEditingController();

  ///
  /// Check whether all input fields are empty or not.
  ///
  bool check() {
    if (!phaseAvailabilityFlag) {
      if (volumeCtrl.text.isEmpty ||
          ampsFirstWireCtrl.text.isEmpty ||
          initTempCtrl.text.isEmpty ||
          targetTempCtrl.text.isEmpty) {
        return false;
      }
    } else {
      if (volumeCtrl.text.isEmpty ||
          ampsFirstWireCtrl.text.isEmpty ||
          ampsSecondWireCtrl.text.isEmpty ||
          ampsThirdWireCtrl.text.isEmpty ||
          initTempCtrl.text.isEmpty ||
          targetTempCtrl.text.isEmpty) {
        return false;
      }
    }

    return true;
  }

  ///
  /// Do a series of actions on amperage value change.
  ///
  /// [wire] - phase wire to use;
  /// [value] - value to process.
  ///
  String onAmperageChange(int wire, String value) {
    double wireValue = initialValue;

    //
    // Parse given value as a decimal number (double).
    //
    if (double.tryParse(value) == null) {
      wireValue = initialValue;
      value = '';
    } else {
      wireValue = double.parse(value);
    }

    //
    // Amperage can't be less than zero.
    //
    if (wireValue < initialValue) {
      wireValue = initialValue;
      value = wireValue.toString();
    }

    //
    // All variables have an upper limit.
    //
    if (wireValue > _ampsLimit) {
      wireValue = _ampsLimit.toDouble();
      value = wireValue.toString();
    }

    setState(
      () {
        switch (wire) {
          case 3:
            {
              timeFormatter.ampsThirdWire = wireValue;
              ampsThirdWireCtrl.text = value;

              break;
            }
          case 2:
            {
              timeFormatter.ampsSecondWire = wireValue;
              ampsSecondWireCtrl.text = value;

              break;
            }
          case 1:
            {
              timeFormatter.ampsFirstWire = wireValue;
              ampsFirstWireCtrl.text = value;

              break;
            }
          default:
            {
              return;
            }
        }

        timeFormatter.coefficient = settings.coolingCoefficientCurrent;

        timeFormatter.calculate();
        set();
      },
    );

    return ampsFirstWireCtrl.text;
  }

  void onInitTempFieldChange(String value) {
    setState(
      () {
        if (double.tryParse(value) == null) {
          timeFormatter.initialTemp = initialValue;
        } else {
          timeFormatter.initialTemp = double.parse(value);
        }

        if (timeFormatter.initialTemp > _initTempLimit || timeFormatter.initialTemp < 0) {
          timeFormatter.initialTemp = _initTempLimit.toDouble();
          initTempCtrl.text = timeFormatter.initialTemp.toString();
        }

        timeFormatter.coefficient = settings.coolingCoefficientCurrent;
        timeFormatter.calculate();

        set();
      },
    );

    return;
  }

  void onTargetTempFieldChange(String value) {
    setState(
      () {
        if (double.tryParse(value) == null) {
          timeFormatter.targetTemp = initialValue;
        } else {
          timeFormatter.targetTemp = double.parse(value);
        }

        //
        // Check whether set temperature is equal to an absolute zero.
        //
        if (timeFormatter.targetTemp == _absoluteZero) {
          if (timeFormatter.voltage == 380 || timeFormatter.voltage == 400) {
            setState(
              () {
                absoluteZeroFlag = true;
              },
            );
          }
        } else {
          setState(
            () {
              absoluteZeroFlag = false;
            },
          );
        }

        if (timeFormatter.targetTemp < _targetTempLimit || timeFormatter.targetTemp > timeFormatter.initialTemp) {
          timeFormatter.targetTemp = -50.0;
          targetTempCtrl.text = timeFormatter.targetTemp.toString();
        }

        timeFormatter.coefficient = settings.coolingCoefficientCurrent;
        timeFormatter.calculate();

        set();
      },
    );

    return;
  }

  void onVoltageDropdownSelection(int? value) {
    setState(
      () {
        dropdownValue = value!.toInt();
        timeFormatter.voltage = dropdownValue.toDouble();

        if (timeFormatter.voltage >= 220 && timeFormatter.voltage <= 230) {
          phaseAvailabilityFlag = false;
        } else {
          phaseAvailabilityFlag = true;
        }

        if (check()) {
          if (!phaseAvailabilityFlag) {
            timeFormatter.initialTemp = double.parse(initTempCtrl.text);
            timeFormatter.targetTemp = double.parse(targetTempCtrl.text);
            timeFormatter.volume = double.parse(volumeCtrl.text);
            timeFormatter.ampsFirstWire = double.parse(ampsFirstWireCtrl.text);
          } else {
            timeFormatter.initialTemp = double.parse(initTempCtrl.text);
            timeFormatter.targetTemp = double.parse(targetTempCtrl.text);
            timeFormatter.volume = double.parse(volumeCtrl.text);
            timeFormatter.ampsFirstWire = double.parse(ampsFirstWireCtrl.text);
            timeFormatter.ampsSecondWire = double.parse(ampsSecondWireCtrl.text);
            timeFormatter.ampsThirdWire = double.parse(ampsThirdWireCtrl.text);
          }
        }

        timeFormatter.coefficient = settings.coolingCoefficientCurrent;
        timeFormatter.calculate();

        set();
      },
    );

    return;
  }

  void onVolumeFieldChange(String value) {
    setState(
      () {
        if (double.tryParse(value) == null) {
          timeFormatter.volume = initialValue;
        } else {
          timeFormatter.volume = double.parse(value);
        }

        if (timeFormatter.volume > _volumeLimit) {
          timeFormatter.volume = _volumeLimit.toDouble();
          volumeCtrl.text = timeFormatter.volume.toString();
        }

        timeFormatter.coefficient = settings.coolingCoefficientCurrent;
        timeFormatter.calculate();

        set();
      },
    );

    return;
  }

  ///
  /// Purge all fields from data and reset the calculator.
  ///
  /// * [calculator] - a calculator to reset.
  ///
  Calculator purge(Calculator calculator) {
    const double initialValue = 0.0;

    timeFormatter = TimeFormatter(
      initialTemp: initialValue,
      targetTemp: initialValue,
      volume: initialValue,
      voltage: dropdownValue.toDouble(),
      ampsFirstWire: initialValue,
      ampsSecondWire: initialValue,
      ampsThirdWire: initialValue,
    );

    initTempCtrl.text = targetTempCtrl.text =
        volumeCtrl.text = ampsFirstWireCtrl.text = ampsSecondWireCtrl.text = ampsThirdWireCtrl.text = '';

    return calculator;
  }

  ///
  /// Set cooling time input field after all calculations.
  ///
  void set() {
    coolingTimeHours = timeFormatter.getHours().toString();
    coolingTimeMinutes = timeFormatter
        .getMinutes(
          rFlag: settings.timeRoundingFlag,
          pFlag: settings.minutesRoundingFlag,
        )
        .toString();

    //
    // No point in showing `empty` time.
    //
    if (coolingTimeHours == '0' || coolingTimeMinutes == '0') {
      temperatureOutputCtrl.text = temperatureOutputInitValue;

      return;
    }

    if (absoluteZeroFlag) {
      temperatureOutputCtrl.text = '$coolingTimeHours : $coolingTimeMinutes \u{1f480}';

      return;
    }

    temperatureOutputCtrl.text = '$coolingTimeHours : $coolingTimeMinutes';

    return;
  }
}
