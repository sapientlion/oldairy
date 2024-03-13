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

	  Description: settings route.

*/

import 'package:flutter/material.dart';
import 'package:oldairy/classes/settings.dart';

import '../classes/global.dart';

class SettingsRoute extends StatefulWidget {
  final String title;

  final Settings settings;
  const SettingsRoute({super.key, required this.title, required this.settings});

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  final double _runSpacing = 15.0;
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final TextEditingController _coefficientCtrl = TextEditingController();

  bool _coolingCoefficientLimitFlag = true; // Forbid user from applying the new settings on validation fail.
  bool _updateAvailabilityFlag = true;
  Settings _settings = Settings();
  List<Widget> _widgets = [];

  bool newUpdate = false;

  dynamic result;

  @override
  Widget build(BuildContext context) {
    _settings = widget.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8.0,
        child: ListView.separated(
          itemCount: _widgets.length,
          itemBuilder: (BuildContext context, int index) {
            return _widgets.elementAt(index);
          },
          padding: Global.defaultEdgeInsets,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.black,
              height: 110.0,
            );
          },
          shrinkWrap: true,
        ),
      ),
      bottomNavigationBar: _getControlPanel(context),
    );
  }

  @override
  void dispose() {
    _coefficientCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _getForm();

    setState(
      () {
        _settings = widget.settings;
        _coefficientCtrl.text = widget.settings.coolingCoefficientCurrent.toString();
      },
    );
  }

  void onWattsFieldChange(String value) {
    setState(
      () {
        if (double.tryParse(value) == null) {
          _settings.coolingCoefficientCurrent = _settings.coolingCoefficientLowerLimit;
        } else {
          double temporaryValue = double.tryParse(value)!;

          //
          // Don't save current state of the settings on cooling coefficient validation error.
          //
          if (temporaryValue < _settings.coolingCoefficientLowerLimit ||
              temporaryValue > _settings.coolingCoefficientUpperLimit) {
            _coolingCoefficientLimitFlag = false;
          } else {
            _coolingCoefficientLimitFlag = true;
            _settings.coolingCoefficientCurrent = double.parse(_coefficientCtrl.text);
          }
        }
      },
    );

    return;
  }

  ///
  /// Summon AlertDialog on validation fail.
  ///
  //
  // TODO use this feature for other options as well.
  //
  Future<void> _getAlertBox() async {
    double coolingCoefficientLowerLimit = _settings.coolingCoefficientLowerLimit;
    double coolingCoefficientUpperLimit = _settings.coolingCoefficientUpperLimit;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Given cooling coefficient value has either underceeded or exceeded the limits.\n'),
                Text('The value must be between $coolingCoefficientLowerLimit and $coolingCoefficientUpperLimit.'),
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

  ///
  /// Get a control panel that is responsible for managing the app settings.
  ///
  BottomAppBar _getControlPanel(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 125,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                setState(
                  () {
                    _settings.reset();

                    _coolingCoefficientLimitFlag = true;
                    _coefficientCtrl.text = _settings.coolingCoefficientCurrent.toString();

                    _dropdownKey.currentState!.reset();

                    return;
                  },
                );
              },
              icon: const Icon(Icons.restore),
              label: const Text('Defaults'),
            ),
          ),
          //
          // Apply current app settings.
          //
          SizedBox(
            width: 125,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                if (!_coolingCoefficientLimitFlag) {
                  _getAlertBox();

                  return;
                }

                _settings.write(_settings);
                Navigator.pop(context, _settings);

                return;
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Get time rounding checkbox.
  ///
  CheckboxListTile _getConversionCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: const Text('Time conversion'),
      value: _settings.timeConversionFlag,
      onChanged: (bool? value) {
        setState(
          () {
            _settings.timeConversionFlag = value!;

            return;
          },
        );
      },
    );
  }

  List<Widget> _getForm() {
    _widgets = [
      Column(
        children: [
          const Center(
            child: Text(
              'General',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_runSpacing),
          ),
          _getConversionCheckbox(),
          Padding(
            padding: EdgeInsets.all(_runSpacing),
          ),
          _getStandardCheckbox(),
        ],
      ),
      Column(
        children: [
          const Center(
            child: Text(
              'Updates',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_runSpacing),
          ),
          CheckboxListTile(
            title: const Text('Check for updates on app startup'),
            controlAffinity: ListTileControlAffinity.leading,
            value: _settings.updateCheckFlag,
            onChanged: (bool? value) {
              setState(
                () {
                  _settings.updateCheckFlag = value!;
                },
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(_runSpacing),
          ),
          _getUpdateCheckButton(),
        ],
      ),
      Column(
        children: [
          const Center(
            child: Text(
              'Experimental',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_runSpacing),
          ),
          _getWattsField(),
        ],
      )
    ];

    return _widgets;
  }

  ///
  /// Get voltage standard checkbox.
  ///
  CheckboxListTile _getStandardCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: const Text('Enable 220/380 Support'),
      value: _settings.oldStandardFlag,
      onChanged: (bool? value) {
        setState(
          () {
            _settings.oldStandardFlag = value!;

            return;
          },
        );
      },
    );
  }

  ///
  /// Let user know about a new update (if any).
  ///
  /// [state] - using this flag determine whether a new update exists or not.
  ///
  Future<void> _getUpdateCheckAlertBox(bool state) async {
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

  FloatingActionButton _getUpdateCheckButton() {
    return FloatingActionButton.extended(
      icon: _updateAvailabilityFlag
          ? const Icon(Icons.check_circle)
          : const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
      label: const Text('Check for updates'),
      onPressed: () {
        //
        // Show circular indicator while the app is checking for any new updates.
        //
        setState(
          () {
            _updateAvailabilityFlag = false;

            return;
          },
        );

        Iterable<Future<dynamic>> updateCheck = [_settings.checkUpdate()];

        //
        // Wait for the function to finish its task.
        //
        Future.wait(updateCheck);

        //
        // Hide circular indicator when finished with update check.
        //
        setState(
          () {
            _settings.checkUpdate().whenComplete(
              () {
                setState(
                  () {
                    _updateAvailabilityFlag = true;
                  },
                );

                if (_settings.responseBody == '') {
                  _getUpdateCheckAlertBox(false);
                } else {
                  if (_settings.packageVersion != _settings.responseBody['tag_name']) {
                    _getUpdateCheckAlertBox(true);
                  } else {
                    _getUpdateCheckAlertBox(false);
                  }
                }
              },
            );
          },
        );
      },
    );
  }

  ///
  /// Get cooling coefficient field.
  ///
  TextField _getWattsField() {
    return TextField(
      autocorrect: false,
      controller: _coefficientCtrl,
      decoration: const InputDecoration(
        counterText: '',
        hintText: '0.0',
        label: Center(
          child: Text('Cooling Coefficient'),
        ),
      ),
      keyboardType: TextInputType.number,
      maxLength: 5,
      onChanged: (value) {
        onWattsFieldChange(value);

        _coefficientCtrl.selection = TextSelection.fromPosition(
          TextPosition(
            offset: _coefficientCtrl.text.length,
          ),
        );
      },
      onTap: () {
        _coefficientCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _coefficientCtrl.text.length,
        );

        return;
      },
      textAlign: TextAlign.center,
    );
  }
}
