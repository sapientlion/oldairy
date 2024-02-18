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
  final double initValue = 0.0;

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
  ));

  @protected
  TextEditingController initTempCtrl = TextEditingController();
  @protected
  TextEditingController targetTempCtrl = TextEditingController();
  @protected
  TextEditingController volumeCtrl = TextEditingController();
  @protected
  TextEditingController ampsFirstWireCtrl = TextEditingController();
  @protected
  TextEditingController ampsSecondWireCtrl = TextEditingController();
  @protected
  TextEditingController ampsThirdWireCtrl = TextEditingController();

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
}
