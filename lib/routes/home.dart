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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:oldairy/routes/about.dart';
import 'package:oldairy/routes/home_manager.dart';
import 'package:oldairy/routes/settings.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key, required this.title});

  final String title;

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends HomeRouteStateManager {
  final int _initTempLimit = 50;
  final int _volumeLimit = 30000;
  final int _ampsLimit = 125;
  final double _tempOutputFontSize = 25;
  final double _absoluteZero = -273.15;
  final double _setTempLimit = -50.0;
  final double _fieldHeight = 70.0;
  final double _fieldWidth = 110.0;
  final double _resetBtnWidth = 50.0;
  final Color _fontColor = const Color.fromRGBO(0, 0, 0, 1);

  bool _azFlag = false; // Absolute zero flag.
  bool _phaseAvailabilityFlag = false; // Three-phase electricity switch.
  List<int> _voltages = <int>[230, 400]; // Store ISO-approved voltages here.

  _HomeRouteState() {
    dropdownValue = _voltages.first;

    initTempCtrl.text = initValue.toString();
    targetTempCtrl.text = initValue.toString();
    volumeCtrl.text = initValue.toString();
    ampsFirstWireCtrl.text = initValue.toString();
    ampsSecondWireCtrl.text = initValue.toString();
    ampsThirdWireCtrl.text = initValue.toString();

    //
    // Don't forget to initialize the voltage located inside of the calculator object.
    //
    timeFormatter.calculator.voltage = _voltages.first.toDouble();
  }

  //
  // Get settings route on screen.
  //
  void getSettingsRoute() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsRoute(
          title: widget.title,
          settings: settings,
        ),
      ),
    );

    //
    // Transfer newly applied settings from settings route to home route.
    //
    setState(() {
      settings = result;
    });

    //
    // Change UI language.
    //
    switchLocale(settings.localeCurrent);

    //
    // Do calculate after applying the app settings.
    //
    timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
    timeFormatter.calculator.calculate();

    //
    // Show final results on screen.
    //
    set();

    return;
  }

  //
  // Get about route on screen.
  //
  void getAboutRoute() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutRoute(
          title: widget.title,
          settings: settings,
        ),
      ),
    );

    return;
  }

  //
  // React to popup menu button presses.
  //
  void doPopupAction(int value) async {
    switch (value) {
      //
      // Open the settings route.
      //
      case 1:
        {
          getSettingsRoute();

          return;
        }
      //
      // Open the about route.
      //
      case 2:
        {
          getAboutRoute();

          return;
        }
      //
      // Terminate app altogether.
      //
      case 3:
        {
          SystemNavigator.pop();

          return;
        }
    }

    return;
  }

  PopupMenuButton<int> getPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 1,
            child: settings.locale.settings.isEmpty ? const Text("Settings") : Text(settings.locale.settings),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: settings.locale.about.isEmpty ? const Text("About") : Text(settings.locale.about),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: settings.locale.exit.isEmpty ? const Text("Exit") : Text(settings.locale.exit),
          ),
        ];
      },
      onSelected: (value) async {
        doPopupAction(value);
      },
    );
  }

  Wrap getTempOutput() {
    return Wrap(
      children: [
        settings.locale.hours.isEmpty
            ? Text(
                '$coolingTimeHours h. ',
                style: TextStyle(
                  fontSize: _tempOutputFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ) // Trailing space is intentional. Do not remove!
            : Text(
                '$coolingTimeHours ${settings.locale.hours}',
                style: TextStyle(
                  fontSize: _tempOutputFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
        settings.locale.minutes.isEmpty
            ? Text(
                '$coolingTimeMinutes m.',
                style: TextStyle(
                  fontSize: _tempOutputFontSize,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                '$coolingTimeMinutes ${settings.locale.minutes}',
                style: TextStyle(
                  fontSize: _tempOutputFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
        //
        // Nothing to see here...
        //
        _azFlag && settings.osFlag
            ? Text(
                '\u{1f480}',
                style: TextStyle(
                  fontSize: _tempOutputFontSize,
                ),
              )
            : const Text(''),
      ],
    );
  }

  FloatingActionButton getClearAllButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        setState(() {
          coolingTimeHours = '0';
          coolingTimeMinutes = '0';
        });

        purge(timeFormatter.calculator);
      },
      label: settings.locale.clearAll.isEmpty ? const Text('Clear All') : Text(settings.locale.clearAll),
    );
  }

  void onVoltageDropdownSelection(int? value) {
    setState(() {
      dropdownValue = value!;
      timeFormatter.calculator.voltage = value.toDouble();

      if (timeFormatter.calculator.voltage >= 220 && timeFormatter.calculator.voltage <= 230) {
        _phaseAvailabilityFlag = false;
      } else {
        _phaseAvailabilityFlag = true;
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

  DropdownButtonFormField<int> getVoltageDropdown() {
    //
    // Check for the currently set voltages standard. Also, do this to prevent app from crashing due to the missing
    // values.
    //
    if (!settings.osFlag) {
      _voltages = <int>[230, 400];
      dropdownValue = _voltages.first;
    } else {
      _voltages = <int>[220, 230, 380, 400];
    }

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 1),
        label: Center(
          child: settings.locale.voltage.isEmpty ? const Text('Voltage') : Text(settings.locale.voltage),
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
        //fontSize: 20,
      ),
      value: dropdownValue,
      icon: const Visibility(
        visible: false,
        child: Icon(Icons.abc),
      ),
      isExpanded: true,
      items: _voltages.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Center(
            child: Text(value.toString()),
          ),
        );
      }).toList(),
      onChanged: (int? value) {
        //
        // This is called when the user selects an item.
        //
        onVoltageDropdownSelection(value);
      },
    );
  }

  void onFirstWireFieldChange(String value) {
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

  SizedBox getFirstWireField() {
    return SizedBox(
      width: _fieldWidth,
      child: TextFormField(
        autocorrect: false,
        controller: ampsFirstWireCtrl,
        decoration: InputDecoration(
          counterStyle: const TextStyle(height: double.minPositive),
          counterText: '',
          filled: true,
          fillColor: const Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child:
                settings.locale.ampsFirstWire.isEmpty ? const Text('Amperage 1') : Text(settings.locale.ampsFirstWire),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onFirstWireFieldChange(value);

          ampsFirstWireCtrl.selection = TextSelection.fromPosition(
            TextPosition(
              offset: ampsFirstWireCtrl.text.length,
            ),
          );
        },
        onTap: () {
          ampsFirstWireCtrl.selection = TextSelection(
            baseOffset: 0,
            extentOffset: ampsFirstWireCtrl.value.text.length,
          );
        },
        /*style: const TextStyle(
        fontSize: 20,
      ),*/
        textAlign: TextAlign.center,
      ),
    );
  }

  void onSecondWireFieldChange(String value) {
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

  Visibility getSecondWireField() {
    return Visibility(
      visible: _phaseAvailabilityFlag,
      child: TextFormField(
        autocorrect: false,
        controller: ampsSecondWireCtrl,
        decoration: InputDecoration(
          counterStyle: const TextStyle(
            height: double.minPositive,
          ),
          counterText: '',
          filled: true,
          fillColor: const Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child: settings.locale.ampsSecondWire.isEmpty
                ? const Text('Amperage 2')
                : Text(settings.locale.ampsSecondWire),
          ),
          labelStyle: TextStyle(
            color: _fontColor,
          ),
        ),
        enabled: _phaseAvailabilityFlag,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onSecondWireFieldChange(value);

          ampsSecondWireCtrl.selection = TextSelection.fromPosition(
            TextPosition(
              offset: ampsSecondWireCtrl.text.length,
            ),
          );
        },
        onTap: () {
          ampsSecondWireCtrl.selection = TextSelection(
            baseOffset: 0,
            extentOffset: ampsSecondWireCtrl.value.text.length,
          );
        },
        textAlign: TextAlign.center,
      ),
    );
  }

  void onThirdWireChange(String value) {
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

  Visibility getThirdWireField() {
    return Visibility(
      visible: _phaseAvailabilityFlag,
      child: TextFormField(
        autocorrect: false,
        controller: ampsThirdWireCtrl,
        decoration: InputDecoration(
          counterStyle: const TextStyle(
            height: double.minPositive,
          ),
          counterText: '',
          filled: true,
          fillColor: const Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child:
                settings.locale.ampsThirdWire.isEmpty ? const Text('Amperage 3') : Text(settings.locale.ampsThirdWire),
          ),
          labelStyle: TextStyle(
            color: _fontColor,
          ),
        ),
        enabled: _phaseAvailabilityFlag,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onThirdWireChange(value);

          ampsThirdWireCtrl.selection = TextSelection.fromPosition(
            TextPosition(
              offset: ampsThirdWireCtrl.text.length,
            ),
          );
        },
        onTap: () {
          ampsThirdWireCtrl.selection = TextSelection(
            baseOffset: 0,
            extentOffset: ampsThirdWireCtrl.value.text.length,
          );
        },
        textAlign: TextAlign.center,
      ),
    );
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

  SizedBox getInitTempField() {
    return SizedBox(
      width: _fieldWidth,
      child: TextFormField(
        autocorrect: false,
        controller: initTempCtrl,
        //
        // Get rid of the counter; do the same thing for
        // other fields as well.
        //
        decoration: InputDecoration(
          counterStyle: const TextStyle(
            height: double.minPositive,
          ),
          counterText: '',
          filled: true,
          fillColor: const Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child: settings.locale.initialTemp.isEmpty ? const Text('Initial Temp') : Text(settings.locale.initialTemp),
          ),
        ),
        /*style: const TextStyle(
        fontSize: 20,
      ),*/
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onInitTempFieldChange(value);

          initTempCtrl.selection = TextSelection.fromPosition(
            TextPosition(
              offset: initTempCtrl.text.length,
            ),
          );
        },
        onTap: () {
          initTempCtrl.selection = TextSelection(
            baseOffset: 0,
            extentOffset: initTempCtrl.value.text.length,
          );
        },
        textAlign: TextAlign.center,
      ),
    );
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
          _azFlag = true;
        });
      } else {
        setState(() {
          _azFlag = false;
        });
      }

      if (!_azFlag) {
        if (timeFormatter.calculator.setTemp < _setTempLimit || timeFormatter.calculator.setTemp > _initTempLimit) {
          timeFormatter.calculator.setTemp = _setTempLimit;
          targetTempCtrl.text = timeFormatter.calculator.setTemp.toString();
        }
      }

      timeFormatter.calculator.kWatts = settings.coolingCoefficientCurrent;
      timeFormatter.calculator.calculate();

      set();
    });

    return;
  }

  SizedBox getTargetTempField() {
    return SizedBox(
      width: _fieldWidth,
      child: TextFormField(
        autocorrect: false,
        controller: targetTempCtrl,
        decoration: InputDecoration(
          counterStyle: const TextStyle(height: double.minPositive),
          counterText: '',
          filled: true,
          fillColor: const Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child: settings.locale.setTemp.isEmpty ? const Text('Target Temp') : Text(settings.locale.setTemp),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onTargetTempFieldChange(value);

          targetTempCtrl.selection = TextSelection.fromPosition(
            TextPosition(
              offset: targetTempCtrl.text.length,
            ),
          );
        },
        onTap: () {
          targetTempCtrl.selection = TextSelection(
            baseOffset: 0,
            extentOffset: targetTempCtrl.value.text.length,
          );
        },
        /*style: const TextStyle(
        fontSize: 20,
      ),*/
        textAlign: TextAlign.center,
      ),
    );
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

  SizedBox getVolumeField() {
    return SizedBox(
      width: _fieldWidth,
      child: TextFormField(
        autocorrect: false,
        controller: volumeCtrl,
        decoration: InputDecoration(
          counterStyle: const TextStyle(height: double.minPositive),
          counterText: '',
          filled: true,
          fillColor: const Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child: settings.locale.volume.isEmpty ? const Text('Volume') : Text(settings.locale.volume),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onVolumeFieldChange(value);

          volumeCtrl.selection = TextSelection.fromPosition(
            TextPosition(
              offset: volumeCtrl.text.length,
            ),
          );
        },
        onTap: () {
          volumeCtrl.selection = TextSelection(
            baseOffset: 0,
            extentOffset: volumeCtrl.value.text.length,
          );
        },
        /*style: const TextStyle(
        fontSize: 20,
      ),*/
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    settings.read().then((value) {
      setState(() {
        bool lFlag = true;
        Map<String, dynamic> json = jsonDecode(value);

        //
        // Load app settings from a map.
        //
        settings.osFlag = json['isOldStandardEnabled'];
        settings.rFlag = json['isTimeRoundingEnabled'];
        settings.pFlag = json['areAbsoluteValuesAllowed'];
        settings.coolingCoefficientCurrent = json['coefficient'];
        settings.localeCurrent = json['currentLocale'];
        settings.localeName = json['localeFile'];

        readLocale(settings.localeName).then((value) {
          lFlag = value;
        });

        //
        // Requested locale may be absent from the disk.
        //
        if (!lFlag) {
          readLocale('en_us.json');
        }
      });
    });
  }

  @override
  void dispose() {
    initTempCtrl.dispose();
    targetTempCtrl.dispose();
    volumeCtrl.dispose();
    ampsFirstWireCtrl.dispose();
    ampsSecondWireCtrl.dispose();
    ampsThirdWireCtrl.dispose();
    super.dispose();
  }

  SizedBox getResetButton(void Function()? onPressed) {
    return SizedBox(
      height: _fieldHeight,
      width: _resetBtnWidth,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: const Icon(Icons.restart_alt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          getPopupMenuButton(context),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8.0,
        child: Center(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            child: Column(
              children: <Widget>[
                Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getTempOutput(),
                      const Padding(
                        padding: EdgeInsets.all(15),
                      ),
                      getClearAllButton(),
                      const Padding(
                        padding: EdgeInsets.all(15),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 30,
                        spacing: 30,
                        children: [
                          SizedBox(
                            width: _fieldWidth + _resetBtnWidth,
                            child: Row(
                              children: [
                                getVolumeField(),
                                getResetButton(() {
                                  volumeCtrl.text = '';

                                  onVolumeFieldChange(volumeCtrl.text);
                                }),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: _fieldWidth + _resetBtnWidth,
                            child: Row(
                              children: [
                                getFirstWireField(),
                                getResetButton(() {
                                  ampsFirstWireCtrl.text = '';

                                  onFirstWireFieldChange(ampsFirstWireCtrl.text);
                                }),
                              ],
                            ),
                          ),
                          /*SizedBox(
                            width: _fieldWidth,
                            child: getFirstWireField(),
                          ),*/
                          SizedBox(
                            width: _fieldWidth,
                            child: getSecondWireField(),
                          ),
                          SizedBox(
                            width: _fieldWidth,
                            child: getThirdWireField(),
                          ),
                          SizedBox(
                            width: _fieldWidth + _resetBtnWidth,
                            child: Row(
                              children: [
                                getInitTempField(),
                                getResetButton(() {
                                  initTempCtrl.text = '';

                                  onInitTempFieldChange(initTempCtrl.text);
                                }),
                              ],
                            ),
                          ),
                          /*SizedBox(
                            width: _fieldWidth,
                            child: getInitTempField(),
                          ),*/
                          SizedBox(
                            width: _fieldWidth + _resetBtnWidth,
                            child: Row(
                              children: [
                                getTargetTempField(),
                                getResetButton(() {
                                  targetTempCtrl.text = '';

                                  onTargetTempFieldChange(targetTempCtrl.text);
                                }),
                              ],
                            ),
                          ),
                          /*SizedBox(
                            width: _fieldWidth,
                            child: getSetTempField(),
                          ),*/
                          SizedBox(
                            width: _fieldWidth,
                            child: getVoltageDropdown(),
                          ),
                          /*SizedBox(
                            width: _fieldWidth,
                            child: getVolumeField(),
                          ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
