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
  final String title;

  const HomeRoute({super.key, required this.title});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends HomeRouteStateManager {
  final double _tempOutputFontSize = 25.0;
  final double _fieldHeight = 70.0;
  final double _fieldWidth = 110.0;
  final double _resetBtnWidth = 40.0;

  List<int> _voltages = <int>[230, 400]; // Store ISO-approved voltages here.

  _HomeRouteState() {
    dropdownValue = _voltages.first;

    temperatureOutputCtrl.text = temperatureOutputInitValue;
    /*volumeCtrl.text = initValue.toString();
    ampsFirstWireCtrl.text = initValue.toString();
    ampsSecondWireCtrl.text = initValue.toString();
    ampsThirdWireCtrl.text = initValue.toString();
    initTempCtrl.text = initValue.toString();
    targetTempCtrl.text = initValue.toString();*/

    //
    // Don't forget to initialize the voltage located inside of the calculator object.
    //
    timeFormatter.calculator.voltage = _voltages.first.toDouble();
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
        thickness: 10.0,
        child: Center(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            child: Form(
              child: Column(
                children: [
                  getTemperatureOutput(),
                  const Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  getClearAllButton(),
                  const Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Wrap(
                    runSpacing: 30,
                    spacing: 30,
                    children: getForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    temperatureOutputCtrl.dispose();
    volumeCtrl.dispose();
    ampsFirstWireCtrl.dispose();
    ampsSecondWireCtrl.dispose();
    ampsThirdWireCtrl.dispose();
    initTempCtrl.dispose();
    targetTempCtrl.dispose();

    super.dispose();
  }

  ///
  /// Get a response whenever popup menu button is pressed by the user.
  ///
  /// [value] - menu option.
  ///
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

  ///
  /// Get the about route on screen.
  ///
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

  ///
  /// Get clear all button that removes all data stored inside of all input fields.
  ///
  FloatingActionButton getClearAllButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        temperatureOutputCtrl.text = temperatureOutputInitValue;

        purge(timeFormatter.calculator);
      },
      label: settings.locale.clearAll.isEmpty ? const Text('Clear All') : Text(settings.locale.clearAll),
    );
  }

  ///
  /// Get first amperage input field.
  ///
  SizedBox getFirstAmperageField() {
    return getInputField(
      label: 'Amperage 1 (A)',
      controller: ampsFirstWireCtrl,
      hintText: '0.0',
      onChanged: (value) {
        onFirstAmperageFieldChange(value);

        ampsFirstWireCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: ampsFirstWireCtrl.text.length,
          ),
        );

        return;
      },
      /*SizedBox getFirstAmperageField() {
    return getInputField(
      'Amperage 1',
      ampsFirstWireCtrl,
      (value) {
        onFirstAmperageFieldChange(value);

        ampsFirstWireCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: ampsFirstWireCtrl.text.length,
          ),
        );

        return;
      },*/
      /*() {
        ampsFirstWireCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: ampsFirstWireCtrl.value.text.length,
        );

        return;
      },*/
    );
  }

  ///
  /// Get a list of all form widgets. Before storing them, ensure that all widgets are encapsulated
  /// within a simple container thus getting a structurally sound UI layout.
  ///
  /// * [widgets] - form widgets storage.
  ///
  List<Widget> getForm() {
    List<Widget> widgetChildren = [];
    List<Widget> widgets = [];

    //
    // Create a widget and attach reset button to it.
    //
    for (int index = 0; index < 6; index++) {
      switch (index) {
        case 0:
          {
            widgetChildren = [
              getVolumeField(),
              getResetButton(
                onPressed: () {
                  volumeCtrl.text = '';

                  onVolumeFieldChange(volumeCtrl.text);

                  return;
                },
              ),
            ];

            break;
          }
        case 1:
          {
            widgetChildren = [
              getFirstAmperageField(),
              getResetButton(
                onPressed: () {
                  ampsFirstWireCtrl.text = '';

                  onFirstAmperageFieldChange(ampsFirstWireCtrl.text);

                  return;
                },
              ),
            ];

            break;
          }
        case 2:
          {
            widgetChildren = [
              getSecondAmperageField(),
              getResetButton(
                onPressed: () {
                  ampsSecondWireCtrl.text = '';

                  onSecondAmperageFieldChange(ampsSecondWireCtrl.text);

                  return;
                },
                enabled: true,
              ),
            ];

            break;
          }
        case 3:
          {
            widgetChildren = [
              getThirdAmperageField(),
              getResetButton(
                onPressed: () {
                  ampsThirdWireCtrl.text = '';

                  onThirdAmperageFieldChange(ampsThirdWireCtrl.text);

                  return;
                },
                enabled: true,
              ),
            ];

            break;
          }
        case 4:
          {
            widgetChildren = [
              getInitTempField(),
              getResetButton(
                onPressed: () {
                  initTempCtrl.text = '';

                  onInitTempFieldChange(initTempCtrl.text);

                  return;
                },
              ),
            ];

            break;
          }
        case 5:
          {
            widgetChildren = [
              getTargetTempField(),
              getResetButton(
                onPressed: () {
                  targetTempCtrl.text = '';

                  onTargetTempFieldChange(targetTempCtrl.text);

                  return;
                },
              ),
            ];

            break;
          }
      }

      //
      // Store newly created widget inside of the `SizedBox` to avoid any potential errors.
      //
      widgets.add(
        SizedBox(
          width: _fieldWidth + _resetBtnWidth,
          child: Row(
            children: widgetChildren,
          ),
        ),
      );
    }

    //
    // Voltage dropdown menu is a separate entity that must be treated in a different way.
    //
    widgets.add(
      SizedBox(
        width: _fieldWidth * 2 + 110,
        child: Row(
          children: [
            getVoltageDropdown(),
            //
            // TODO finish implementation of the reset routine for voltage dropdown menu.
            //
            getResetButton(
              onPressed: () {
                setState(() {
                  dropdownValue = _voltages.first;

                });

                return;
              },
            ),
          ],
        ),
      ),
    );

    return widgets;
  }

  ///
  /// Get initial temperature input field on screen.
  ///
  SizedBox getInitTempField() {
    return getInputField(
      label: 'Initial Temp',
      controller: initTempCtrl,
      hintText: '0.0',
      onChanged: (value) {
        onInitTempFieldChange(value);

        initTempCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: initTempCtrl.text.length,
          ),
        );

        return;
      },
      /*SizedBox getInitTempField() {
    return getInputField(
      'Initial Temp',
      initTempCtrl,
      (value) {
        onInitTempFieldChange(value);

        initTempCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: initTempCtrl.text.length,
          ),
        );

        return;
      },*/
      /*() {
        initTempCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: initTempCtrl.value.text.length,
        );

        return;
      },*/
    );
  }

  ///
  /// Get a generic input field.
  ///
  /// * [label] - input field label as String;
  /// * [hintText] - input suggestion to show before entering text, as String;
  /// * [controller] - typical text controller for altering the text as TextEditingController;
  /// * [onChanged] - series of routines that follow after editing the contents of input field;
  /// * [enabled] - input field state;
  /// * [onTap] - series of routines that follow after tapping on input field.
  ///
  SizedBox getInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required Function(String)? onChanged,
    bool enabled = false,
    void Function()? onTap,
  }) {
    /*SizedBox getInputField(
      String label, TextEditingController controller, void Function(String)? onChanged,
      {bool enabled = false, void Function()? onTap}) {*/
    /*SizedBox getInputField(
      String label, TextEditingController controller, void Function(String)? onChanged, void Function()? onTap,
      {bool enabled = false}) {*/
    return SizedBox(
      width: _fieldWidth,
      child: TextFormField(
        autocorrect: false,
        controller: controller,
        //
        // Get rid of the counter.
        //
        decoration: InputDecoration(
          counterStyle: const TextStyle(height: double.minPositive),
          counterText: '',
          filled: true,
          fillColor: const Color.fromRGBO(211, 211, 211, 1),
          hintText: hintText,
          label: Center(
            child: Text(label),
          ),
        ),
        enabled: !enabled ? null : phaseAvailabilityFlag,
        //
        // Accept numbers only.
        //
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        onTap: onTap,
        textAlign: TextAlign.center,
      ),
    );
  }

  ///
  /// Get a popup menu that allows traversal between different app routes.
  ///
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
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              Icon(Icons.menu),
              Text('Menu'),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Get a generic reset button.
  ///
  /// * [onPressed] - what must happen after pressing the button;
  /// * [enabled] - state of the button.
  ///
  SizedBox getResetButton({
    required void Function()? onPressed,
    bool enabled = false,
  }) {
    return SizedBox(
      height: _fieldHeight,
      width: _resetBtnWidth,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        onPressed: !enabled
            ? onPressed
            : !phaseAvailabilityFlag
                ? null
                : onPressed,
        child: const Icon(Icons.restart_alt),
      ),
    );
  }

  SizedBox getSecondAmperageField() {
    return getInputField(
      label: 'Amperage 2 (A)',
      controller: ampsSecondWireCtrl,
      hintText: '0.0',
      onChanged: (value) {
        onSecondAmperageFieldChange(value);

        ampsSecondWireCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: ampsSecondWireCtrl.text.length,
          ),
        );

        return;
      },
      /*SizedBox getSecondAmperageField() {
    return getInputField(
      'Amperage 2',
      ampsSecondWireCtrl,
      (value) {
        onSecondAmperageFieldChange(value);

        ampsSecondWireCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: ampsSecondWireCtrl.text.length,
          ),
        );

        return;
      },*/
      /*() {
        ampsSecondWireCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: ampsSecondWireCtrl.value.text.length,
        );

        return;
      },*/
      enabled: true,
    );
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

  SizedBox getTargetTempField() {
    return getInputField(
      label: 'Target Temp',
      controller: targetTempCtrl,
      hintText: '0.0',
      onChanged: (value) {
        onTargetTempFieldChange(value);

        targetTempCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: targetTempCtrl.text.length,
          ),
        );

        return;
      },
      /*SizedBox getTargetTempField() {
    return getInputField(
      'Target Temp',
      targetTempCtrl,
      (value) {
        onTargetTempFieldChange(value);

        targetTempCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: targetTempCtrl.text.length,
          ),
        );

        return;
      },*/
      /*() {
        targetTempCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: targetTempCtrl.value.text.length,
        );

        return;
      },*/
    );
  }

  Row getTemperatureOutput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _fieldWidth * 2 + 110,
          child: TextFormField(
            controller: temperatureOutputCtrl,
            decoration: const InputDecoration(
              counterStyle: TextStyle(height: double.minPositive),
              counterText: '',
              filled: true,
              fillColor: Color.fromRGBO(211, 211, 211, 1),
              label: Center(
                child: Text('Cooling Time (hh:mm)'),
              ),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
          ),
        ),
        //
        // Nothing to see here...
        //
        /*absoluteZeroFlag && settings.osFlag
            ? Text(
                '\u{1f480}',
                style: TextStyle(
                  fontSize: _tempOutputFontSize,
                ),
              )
            : const Text(''),*/
      ],
    );
  }

  SizedBox getThirdAmperageField() {
    return getInputField(
      label: 'Amperage 3 (A)',
      controller: ampsThirdWireCtrl,
      hintText: '0.0',
      onChanged: (value) {
        onThirdAmperageFieldChange(value);

        ampsThirdWireCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: ampsThirdWireCtrl.text.length,
          ),
        );

        return;
      },
      /*SizedBox getThirdAmperageField() {
    return getInputField(
      'Amperage 3',
      ampsThirdWireCtrl,
      (value) {
        onThirdAmperageFieldChange(value);

        ampsThirdWireCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: ampsThirdWireCtrl.text.length,
          ),
        );

        return;
      },*/
      /*() {
        ampsThirdWireCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: ampsThirdWireCtrl.value.text.length,
        );

        return;
      },*/
      enabled: true,
    );
  }

  SizedBox getVoltageDropdown() {
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

    return SizedBox(
      width: _fieldWidth * 2 + 70.0,
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child: Text('Voltage (V)'),
            //child: settings.locale.voltage.isEmpty ? const Text('Voltage (V)') : Text(settings.locale.voltage),
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
          //onChanged: (int? value) {
          //
          // This is called when the user selects an item.
          //
          onVoltageDropdownSelection(value);

          return;
        },
      ),
    );
  }

  SizedBox getVolumeField() {
    return getInputField(
      label: 'Volume (L)',
      controller: volumeCtrl,
      hintText: '0.0',
      onChanged: (value) {
        onVolumeFieldChange(value);

        volumeCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: volumeCtrl.text.length,
          ),
        );

        return;
      },
      /*SizedBox getVolumeField() {
    return getInputField(
      'Volume',
      volumeCtrl,
      (value) {
        onVolumeFieldChange(value);

        volumeCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: volumeCtrl.text.length,
          ),
        );

        return;
      },*/
      /*() {
        volumeCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: volumeCtrl.value.text.length,
        );

        return;
      },*/
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
}
