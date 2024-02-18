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
  const SettingsRoute({super.key, required this.title, required this.settings});

  final String title;
  final Settings settings;

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  final double _edgeInsetsSize = 30.0;
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final TextEditingController _coefficientCtrl = TextEditingController();
  final List<String> _locales = <String>[
    'English (US)',
    'Serbian (Cyrillic)',
    'Serbian (Latin)',
    'Swedish',
  ];

  bool _coolingCoefficientLimitFlag = true; // Forbid user from applying the new settings on validation fail.
  bool _updateCheckReadinessFlag = true;
  String _dropdownValue = '';
  Settings _settings = Settings();

  //
  // Get language switcher.
  //
  DropdownButtonFormField<String> getLanguageChanger() {
    return DropdownButtonFormField<String>(
      key: _dropdownKey,
      decoration: InputDecoration(
        label: _settings.locale.language.isEmpty ? const Text('Language') : Text(_settings.locale.language),
      ),
      style: const TextStyle(
        color: Colors.black,
        //fontSize: 16,
      ),
      value: _dropdownValue,
      items: _locales.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          _settings.localeCurrent = value!;
        });
      },
    );
  }

  //
  // Get time rounding checkbox.
  //
  CheckboxListTile getRoundingCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: const Text('Time rounding'),
      value: _settings.timeRoundingFlag,
      onChanged: (bool? value) {
        setState(() {
          if (!_settings.timeRoundingFlag) {
            _settings.timeRoundingFlag = true;
          } else {
            _settings.timeRoundingFlag = false;
          }
        });
      },
    );
  }

  //
  // Get time precision checkbox.
  //
  CheckboxListTile getPrecisionCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: const Text('Round minutes'),
      value: _settings.timePrecisionFlag,
      onChanged: (bool? value) {
        setState(() {
          if (!_settings.timePrecisionFlag) {
            _settings.timePrecisionFlag = true;
          } else {
            _settings.timePrecisionFlag = false;
          }
        });
      },
    );
  }

  //
  // Get voltage standard checkbox.
  //
  CheckboxListTile getStandardCheckbox() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: const Color.fromRGBO(211, 211, 211, 0),
      title: _settings.locale.oldStandardSupport.isEmpty
          ? const Text('Enable 220/380 Support')
          : Text(_settings.locale.oldStandardSupport),
      value: _settings.oldStandardFlag,
      onChanged: (bool? value) {
        setState(() {
          if (!_settings.oldStandardFlag) {
            _settings.oldStandardFlag = true;
          } else {
            _settings.oldStandardFlag = false;
          }
        });
      },
    );
  }

  void onWattsFieldChange(String value) {
    setState(() {
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
    });

    return;
  }

  //
  // Get cooling coefficient field.
  //
  TextField getWattsField() {
    return TextField(
      autocorrect: false,
      controller: _coefficientCtrl,
      decoration: const InputDecoration(
        counterStyle: TextStyle(height: double.minPositive),
        counterText: '',
        filled: true,
        fillColor: Color.fromRGBO(211, 211, 211, 1),
        hintText: '0.0',
        label: Center(
          child: Text('Cooling Coefficient (TEST)'),
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

  //
  // Summon AlertDialog on validation fail.
  //
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

  FloatingActionButton getUpdateCheckButton() {
    return FloatingActionButton.extended(
        icon: _updateCheckReadinessFlag
            ? null
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
            _updateCheckReadinessFlag = false;
          });

          Iterable<Future<dynamic>> updateCheck = [_settings.checkUpdate()];

          //
          // Wait for the function to finish its task.
          //
          Future.wait(updateCheck);

          //
          // Hide circular indicator when finished with update check.
          //
          setState(() {
            _settings.checkUpdate().whenComplete(() {
              setState(() {
                _updateCheckReadinessFlag = true;
              });
            });
          });
        });
  }

  //
  // Get a control panel that is responsible for managing the app settings.
  //
  BottomAppBar getControlPanel(BuildContext context) {
    return BottomAppBar(
      color: Colors.green,
      padding: const EdgeInsets.all(16.0),
      shadowColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 128,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              heroTag: null,
              onPressed: () {
                setState(() {
                  _settings.reset();

                  _settings.localeCurrent = _dropdownValue = _locales.first;
                  _coolingCoefficientLimitFlag = true;
                  _coefficientCtrl.text = _settings.coolingCoefficientCurrent.toString();

                  _dropdownKey.currentState!.reset();
                });

                /*setState(() {
                  _settings.oldStandardFlag = false;
                  _settings.timePrecisionFlag = true;
                  _settings.timeRoundingFlag = true;
                  _settings.coolingCoefficientCurrent = _settings.coolingCoefficientLowerLimit;
                  _settings.localeCurrent = _dropdownValue = _locales.first;

                  _coolingCoefficientLimitFlag = true;
                  _coefficientCtrl.text = _settings.coolingCoefficientCurrent.toString();
                  _dropdownKey.currentState!.reset();
                });*/
              },
              label: _settings.locale.defaults.isEmpty ? const Text('Defaults') : Text(_settings.locale.defaults),
            ),
          ),
          //
          // Apply current app settings.
          //
          SizedBox(
            width: 128,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
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
              label: _settings.locale.apply.isEmpty ? const Text('Apply') : Text(_settings.locale.apply),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _settings = widget.settings;
      _coefficientCtrl.text = widget.settings.coolingCoefficientCurrent.toString();
      _dropdownValue = widget.settings.localeCurrent;
    });
  }

  @override
  void dispose() {
    _coefficientCtrl.dispose();
    super.dispose();
  }

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
      getLanguageChanger(),
      getPrecisionCheckbox(),
      getRoundingCheckbox(),
      getStandardCheckbox(),
      getWattsField(),
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
      getUpdateCheckButton(),
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
            itemCount: 8),
      ),
      bottomNavigationBar: getControlPanel(context),
    );
  }
}
