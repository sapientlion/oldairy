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

class SettingsRoute extends StatefulWidget {
  final String title;

  final Settings settings;
  const SettingsRoute({super.key, required this.title, required this.settings});

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  final double _edgeInsetsSize = 30.0;
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final TextEditingController _coefficientCtrl = TextEditingController();

  bool _coolingCoefficientLimitFlag = true; // Forbid user from applying the new settings on validation fail.
  bool _updateAvailabilityFlag = true;
  Settings _settings = Settings();

  bool newUpdate = false;

  dynamic result;

  @override
  Widget build(BuildContext context) {
    List<Widget> listViewItems = [
      const ListTile(
        title: Center(
          child: Text(
            'General',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      getPrecisionCheckbox(),
      getRoundingCheckbox(),
      getStandardCheckbox(),
      const ListTile(
        title: Center(
          child: Text(
            'Updates',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
      getUpdateCheckButton(),
      const ListTile(
        title: Center(
          child: Text(
            'Experimental',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      getWattsField(),
    ];

    _settings = widget.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8.0,
        child: ListView.separated(
            padding: EdgeInsets.all(_edgeInsetsSize),
            itemBuilder: (BuildContext context, int index) {
              return listViewItems.elementAt(index);
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(
                  color: Color.fromARGB(0, 0, 0, 0),
                  height: 30.0,
                ),
            itemCount: 9),
      ),
      bottomNavigationBar: getControlPanel(context),
    );
  }

  @override
  void dispose() {
    _coefficientCtrl.dispose();
    super.dispose();
  }

  ///
  /// Summon AlertDialog on validation fail.
  ///
  //
  // TODO use this feature for other options as well.
  //
  Future<void> getAlertBox() async {
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
  BottomAppBar getControlPanel(BuildContext context) {
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
                setState(() {
                  _settings.reset();

                  _coolingCoefficientLimitFlag = true;
                  _coefficientCtrl.text = _settings.coolingCoefficientCurrent.toString();

                  _dropdownKey.currentState!.reset();
                });
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
                  getAlertBox();

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
  /// Get time precision checkbox.
  ///
  CheckboxListTile getPrecisionCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: const Text('Round minutes'),
      value: _settings.minutesRoundingFlag,
      onChanged: (bool? value) {
        setState(() {
          _settings.minutesRoundingFlag = value!;
        });
      },
    );
  }

  ///
  /// Get time rounding checkbox.
  ///
  CheckboxListTile getRoundingCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: const Text('Time rounding'),
      value: _settings.timeRoundingFlag,
      onChanged: (bool? value) {
        setState(() {
          _settings.timeRoundingFlag = value!;
        });
      },
    );
  }

  ///
  /// Get voltage standard checkbox.
  ///
  CheckboxListTile getStandardCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: const Text('Enable 220/380 Support'),
      value: _settings.oldStandardFlag,
      onChanged: (bool? value) {
        setState(() {
          _settings.oldStandardFlag = value!;
        });
      },
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

  FloatingActionButton getUpdateCheckButton() {
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
        setState(() {
          _updateAvailabilityFlag = false;
        });

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
                  getUpdateCheckAlertBox(false);
                } else {
                  if (_settings.packageVersion != _settings.responseBody['tag_name']) {
                    getUpdateCheckAlertBox(true);
                  } else {
                    getUpdateCheckAlertBox(false);
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
  TextField getWattsField() {
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
      },
      textAlign: TextAlign.center,
    );
  }

  @override
  void initState() {
    super.initState();

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
}
