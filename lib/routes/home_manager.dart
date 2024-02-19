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

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:oldairy/classes/calculator.dart';
import 'package:oldairy/classes/settings.dart';
import 'package:oldairy/classes/tformatter.dart';
import 'package:oldairy/routes/home.dart';

abstract class HomeRouteStateManager extends State<HomeRoute> {
  final int _initTempLimit = 50;
  final int _volumeLimit = 30000;
  final int _ampsLimit = 125;
  final double initValue = 0.0;
  final double _targetTempLimit = -50.0;
  final double _absoluteZero = -273.15;

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
    calculator: Calculator(
      initialTemp: 0.0,
      setTemp: 0.0,
      volume: 0.0,
      voltage: 0.0,
      ampsFirstWire: 0.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0,
    ),
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

  //
  // Set cooling time.
  //
  void set() {
    coolingTimeHours = timeFormatter.getHours().toString();
    coolingTimeMinutes = timeFormatter
        .getMinutes(
          rFlag: settings.rFlag,
          pFlag: settings.pFlag,
        )
        .toString();

    temperatureOutputCtrl.text = '$coolingTimeHours : $coolingTimeMinutes';

    return;
  }

  //
  // Re-initialize `TextEditingController` if empty.
  //
  TextEditingController reset(TextEditingController controller) {
    if (controller.value.text.isEmpty) {
      controller.text = initValue.toString();
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.value.text.length,
      );
    }

    return controller;
  }

  //
  // Purge all fields from data.
  //
  Calculator purge(Calculator calculator) {
    timeFormatter = TimeFormatter(
        calculator: Calculator(
            initialTemp: 0.0,
            setTemp: 0.0,
            volume: 0.0,
            voltage: dropdownValue.toDouble(),
            ampsFirstWire: 0.0,
            ampsSecondWire: 0.0,
            ampsThirdWire: 0.0));

    initTempCtrl.text = initValue.toString();
    targetTempCtrl.text = initValue.toString();
    volumeCtrl.text = initValue.toString();
    ampsFirstWireCtrl.text = initValue.toString();
    ampsSecondWireCtrl.text = initValue.toString();
    ampsThirdWireCtrl.text = initValue.toString();

    return calculator;
  }

  //
  // Get specific locale by reading from a specific file.
  //
  Future<bool> readLocale(String name) async {
    String response = '';

    try {
      response = await rootBundle.loadString('assets/locales/$name');
    } catch (e) {
      return false;
    }

    final data = await json.decode(response);
    Map<String, dynamic> locale = data;

    setState(() {
      settings.locale.hours = locale['hours'];
      settings.locale.minutes = locale['minutes'];
      settings.locale.initialTemp = locale['initialTemp'];
      settings.locale.setTemp = locale['setTemp'];
      settings.locale.volume = locale['volume'];
      settings.locale.voltage = locale['voltage'];
      settings.locale.ampsFirstWire = locale['ampFirst'];
      settings.locale.ampsSecondWire = locale['ampSecond'];
      settings.locale.ampsThirdWire = locale['ampThird'];
      settings.locale.clearAll = locale['clearAll'];
      settings.locale.settings = locale['settings'];
      settings.locale.about = locale['about'];
      settings.locale.help = locale['help'];
      settings.locale.exit = locale['exit'];
      settings.locale.general = locale['general'];
      settings.locale.language = locale['language'];
      settings.locale.oldStandardSupport = locale['oldStandard'];
      settings.locale.defaults = locale['defaults'];
      settings.locale.apply = locale['apply'];
    });

    return true;
  }

  //
  // Switch GUI's language to something else.
  //
  //
  // TODO find another way for storing locale names and locale file names.
  //
  String switchLocale(String locale) {
    switch (locale) {
      case 'Serbian (Cyrillic)':
        {
          settings.localeName = 'rs_cyrillic.json';

          readLocale(settings.localeName);

          break;
        }
      case 'Serbian (Latin)':
        {
          settings.localeName = 'rs_latin.json';

          readLocale(settings.localeName);

          break;
        }
      case 'Swedish':
        {
          settings.localeName = 'sv_se.json';

          readLocale(settings.localeName);

          break;
        }
      default:
        {
          settings.localeName = 'en_us.json';

          readLocale(settings.localeName);

          break;
        }
    }

    return locale;
  }



  void onVoltageDropdownSelection(int? value) {
    setState(() {
      dropdownValue = value!;
      timeFormatter.calculator.voltage = value.toDouble();

      if (timeFormatter.calculator.voltage >= 220 && timeFormatter.calculator.voltage <= 230) {
        phaseAvailabilityFlag = false;
      } else {
        phaseAvailabilityFlag = true;
      }

      timeFormatter.calculator.initialTemp = double.parse(initTempCtrl.text);
      timeFormatter.calculator.setTemp = double.parse(targetTempCtrl.text);
      timeFormatter.calculator.volume = double.parse(volumeCtrl.text);
      timeFormatter.calculator.ampsFirstWire = double.parse(ampsFirstWireCtrl.text);
      timeFormatter.calculator.ampsSecondWire = double.parse(ampsSecondWireCtrl.text);
      timeFormatter.calculator.ampsThirdWire = double.parse(ampsThirdWireCtrl.text);

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }

  void onFirstAmperageFieldChange(String value) {
    setState(() {
      ampsFirstWireCtrl = reset(ampsFirstWireCtrl);

      //
      // Input field can't be empty. Prevent that by doing the following.
      //
      if (double.tryParse(value) == null) {
        timeFormatter.calculator.ampsFirstWire = initValue;
      } else {
        timeFormatter.calculator.ampsFirstWire = double.parse(value);
      }

      if (timeFormatter.calculator.ampsFirstWire > _ampsLimit) {
        //
        // Set member value to pre-defined amperage limit.
        //
        timeFormatter.calculator.ampsFirstWire = _ampsLimit.toDouble();
        //
        // Assign a new value to the input field.
        //
        ampsFirstWireCtrl.text = timeFormatter.calculator.ampsFirstWire.toString();
      }

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }

  void onSecondAmperageFieldChange(String value) {
    setState(() {
      ampsSecondWireCtrl = reset(ampsSecondWireCtrl);

      if (double.tryParse(value) == null) {
        timeFormatter.calculator.ampsSecondWire = initValue;
      } else {
        timeFormatter.calculator.ampsSecondWire = double.parse(value);
      }

      if (timeFormatter.calculator.ampsSecondWire > _ampsLimit) {
        timeFormatter.calculator.ampsSecondWire = _ampsLimit.toDouble();
        ampsSecondWireCtrl.text = timeFormatter.calculator.ampsSecondWire.toString();
      }

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }

  void onThirdAmperageFieldChange(String value) {
    setState(() {
      ampsThirdWireCtrl = reset(ampsThirdWireCtrl);

      if (double.tryParse(value) == null) {
        timeFormatter.calculator.ampsThirdWire = initValue;
      } else {
        timeFormatter.calculator.ampsThirdWire = double.parse(value);
      }

      if (timeFormatter.calculator.ampsThirdWire > _ampsLimit) {
        timeFormatter.calculator.ampsThirdWire = _ampsLimit.toDouble();
        ampsThirdWireCtrl.text = timeFormatter.calculator.ampsThirdWire.toString();
      }

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }

  void onInitTempFieldChange(String value) {
    setState(() {
      initTempCtrl = reset(initTempCtrl);

      if (double.tryParse(value) == null) {
        timeFormatter.calculator.initialTemp = initValue;
      } else {
        timeFormatter.calculator.initialTemp = double.parse(value);
      }

      if (timeFormatter.calculator.initialTemp > _initTempLimit || timeFormatter.calculator.initialTemp < 0) {
        timeFormatter.calculator.initialTemp = _initTempLimit.toDouble();
        initTempCtrl.text = timeFormatter.calculator.initialTemp.toString();
      }

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }

  void onTargetTempFieldChange(String value) {
    setState(() {
      targetTempCtrl = reset(targetTempCtrl);

      if (double.tryParse(value) == null) {
        timeFormatter.calculator.setTemp = initValue;
      } else {
        timeFormatter.calculator.setTemp = double.parse(value);
      }

      //
      // Check whether set temperature is equal to an absolute zero.
      //
      if (timeFormatter.calculator.setTemp == _absoluteZero) {
        setState(() {
          absoluteZeroFlag = true;
        });
      } else {
        setState(() {
          absoluteZeroFlag = false;
        });
      }

      if (!absoluteZeroFlag) {
        if (timeFormatter.calculator.setTemp < _targetTempLimit || timeFormatter.calculator.setTemp > _initTempLimit) {
          timeFormatter.calculator.setTemp = _targetTempLimit;
          targetTempCtrl.text = timeFormatter.calculator.setTemp.toString();
        }
      }

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }

  void onVolumeFieldChange(String value) {
    setState(() {
      volumeCtrl = reset(volumeCtrl);

      if (double.tryParse(value) == null) {
        timeFormatter.calculator.volume = initValue;
      } else {
        timeFormatter.calculator.volume = double.parse(value);
      }

      if (timeFormatter.calculator.volume > _volumeLimit) {
        timeFormatter.calculator.volume = _volumeLimit.toDouble();
        volumeCtrl.text = timeFormatter.calculator.volume.toString();
      }

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }
}
