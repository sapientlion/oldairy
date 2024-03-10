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

import '../classes/global.dart';

class HomeRoute extends StatefulWidget {
  final String title;

  const HomeRoute({super.key, required this.title});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends HomeRouteStateManager {
  final double _fieldWidth = 140.0;
  final double _resetBtnWidth = 40.0;
  final double _runSpacingConstant = 2.3;
  final double _runSpacing = 15.0;

  List<int> _voltages = <int>[230, 400]; // Store ISO-approved voltages here.

  _HomeRouteState() {
    dropdownValue = _voltages.first;

    temperatureOutputCtrl.text = temperatureOutputInitValue;

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
                  Padding(
                    padding: EdgeInsets.all(_runSpacing),
                  ),
                  getClearAllButton(),
                  Padding(
                    padding: EdgeInsets.all(_runSpacing),
                  ),
                  Wrap(
                    runSpacing: _runSpacing,
                    children: getForm(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(_runSpacing),
                  ),
                  SizedBox(
                    width: _fieldWidth * _runSpacingConstant,
                    child: getVoltageDropdown(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// Check for any updates.
  ///
  bool checkUpdate() {
    bool updateAvailabilityFlag = false;

    //
    // Show circular indicator while the app is checking for any new updates.
    //
    setState(
      () {
        updateAvailabilityFlag = false;
      },
    );

    Iterable<Future<dynamic>> updateCheck = [settings.checkUpdate()];

    //
    // Wait for the function to finish its task.
    //
    Future.wait(updateCheck);

    //
    // Hide circular indicator when finished with update check.
    //
    setState(
      () {
        settings.checkUpdate().whenComplete(
          () {
            setState(
              () {
                updateAvailabilityFlag = true;
              },
            );

            if (settings.responseBody != '') {
              if (settings.packageVersion != settings.responseBody['tag_name'].toString()) {
                getUpdateCheckAlertBox(true);
              }
            }
          },
        );
      },
    );

    return updateAvailabilityFlag;
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
          title: 'About',
          settings: settings,
        ),
      ),
    );

    return;
  }

  ///
  /// Get clear all button that removes all data stored inside of all input fields.
  ///
  ElevatedButton getClearAllButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.brush),
      label: settings.locale.clearAll.isEmpty ? const Text('Clear All') : Text(settings.locale.clearAll),
      onPressed: () {
        temperatureOutputCtrl.text = temperatureOutputInitValue;

        purge(timeFormatter.calculator);
      },
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
          child: Column(
            children: widgetChildren,
          ),
        ),
      );
    }

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
    return SizedBox(
      width: _fieldWidth,
      child: TextFormField(
        autocorrect: false,
        controller: controller,
        decoration: InputDecoration(
          counterText: '',
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
            child: settings.locale.settings.isEmpty ? const Text('Settings') : Text(settings.locale.settings),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: settings.locale.about.isEmpty ? const Text('About') : Text(settings.locale.about),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: settings.locale.exit.isEmpty ? const Text('Exit') : Text(settings.locale.exit),
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
      height: 35.0,
      width: _fieldWidth,
      child: ElevatedButton.icon(
        onPressed: !enabled
            ? onPressed
            : !phaseAvailabilityFlag
                ? null
                : onPressed,
        icon: const Icon(Icons.restart_alt),
        label: const Text('Reset'),
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
          title: 'Settings',
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
    );
  }

  Row getTemperatureOutput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _fieldWidth * _runSpacingConstant,
          child: TextFormField(
            controller: temperatureOutputCtrl,
            decoration: const InputDecoration(
              counterStyle: TextStyle(height: double.minPositive),
              counterText: '',
              label: Center(
                child: Text('Cooling Time (hh:mm)'),
              ),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
          ),
        ),
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
      enabled: true,
    );
  }

  ///
  /// Let user know about a new update (if any).
  ///
  /// [state] - using this flag determine whether a new update exists or not.
  ///
  Future<void> getUpdateCheckAlertBox(bool state) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                !state ? const Text('Everything is up to date.') : const Text('A new update is available!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();

                return;
              },
            ),
          ],
        );
      },
    );
  }

  SizedBox getVoltageDropdown() {
    //
    // Check for the currently set voltages standard. Also, do this to prevent app from crashing due to the missing
    // values.
    //
    if (!settings.oldStandardFlag) {
      _voltages = <int>[230, 400];
      dropdownValue = _voltages.first;
    } else {
      _voltages = <int>[220, 230, 380, 400];
    }

    return SizedBox(
      width: _fieldWidth * 2.6,
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(
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
        items: _voltages.map<DropdownMenuItem<int>>(
          (int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Center(
                child: Text(value.toString()),
              ),
            );
          },
        ).toList(),
        onChanged: (int? value) {
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
    );
  }

  @override
  void initState() {
    super.initState();

    settings.read().then(
      (value) {
        setState(
          () {
            bool lFlag = true;
            Map<String, dynamic> json = jsonDecode(value);

            //
            // Load app settings from map.
            //
            settings.oldStandardFlag = json[Global.keyOldStandard];
            settings.timeRoundingFlag = json[Global.keyTimeRounding];
            settings.coolingCoefficientCurrent = json[Global.keyCoefficientValue];
            settings.localeCurrent = json[Global.keyLocaleCurrent];
            settings.localeName = json[Global.keyLocaleFile];
            settings.minutesRoundingFlag = json[Global.keyTimeRounding];
            settings.updateCheckFlag = json[Global.keyUpdateCheckOnStartup];

            readLocale(settings.localeName).then(
              (value) {
                lFlag = value;
              },
            );

            //
            // Requested locale may be absent from the disk.
            //
            if (!lFlag) {
              readLocale('en_us.json');
            }

            if (settings.updateCheckFlag) {
              checkUpdate();
            }
          },
        );
      },
    );
  }
}
