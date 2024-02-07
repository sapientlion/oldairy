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
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final TextEditingController _coefficientCtrl = TextEditingController();
  final List<String> _locales = <String>[
    'English (US)',
    'Serbian (Cyrillic)',
    'Serbian (Latin)',
    'Swedish',
  ];

  bool _coolingCoefficientLimitFlag = true;
  String _dropdownValue = '';
  Settings _settings = Settings();

  //
  // Get language switcher.
  //
  DropdownButtonFormField<String> getLanguageChanger() {
    return DropdownButtonFormField<String>(
      key: _dropdownKey,
      decoration: InputDecoration(
        label: _settings.locale.language.isEmpty
            ? const Text('Language')
            : Text(_settings.locale.language),
        /*labelStyle: const TextStyle(
                  fontSize: 20,
                ),*/
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
          _settings.currentLocale = value!;
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
      title: const Text('Enable Time Rounding'),
      value: _settings.rFlag,
      onChanged: (bool? value) {
        setState(() {
          if (!_settings.rFlag) {
            _settings.rFlag = true;
          } else {
            _settings.rFlag = false;
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
      title: const Text('Allow Use of Precise Minutes'),
      value: _settings.pFlag,
      onChanged: (bool? value) {
        setState(() {
          if (!_settings.pFlag) {
            _settings.pFlag = true;
          } else {
            _settings.pFlag = false;
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
          ? const Text('Enable 220V/380V Support')
          : Text(_settings.locale.oldStandardSupport),
      value: _settings.osFlag,
      onChanged: (bool? value) {
        setState(() {
          if (!_settings.osFlag) {
            _settings.osFlag = true;
          } else {
            _settings.osFlag = false;
          }
        });
      },
    );
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
        setState(() {
          if (double.tryParse(value) == null) {
            _settings.coolingCoefficientCurrent = _settings.coolingCoefficientLowerLimit;
          } else {
            double temporaryValue = double.tryParse(value)!;

            if (temporaryValue < _settings.coolingCoefficientLowerLimit || temporaryValue > _settings.coolingCoefficientUpperLimit) {
              _coolingCoefficientLimitFlag = false;
            } else {
              _coolingCoefficientLimitFlag = true;
            }

            _settings.coolingCoefficientCurrent = double.parse(_coefficientCtrl.text);
          }
        });
      },
      onTap: () {
        _coefficientCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _coefficientCtrl.text.length,
        );
      },
      /*style: const TextStyle(
                  fontSize: 20,
                ),*/
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
                const Text(
                    'Given cooling coefficient value has either underceeded or exceeded the limits.\n'),
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

  //
  // Get a control panel that is responsible for managing the app settings.
  //
  BottomAppBar getControlPanel(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16.0),
      shadowColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 128,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                setState(() {
                  _settings.osFlag = false;
                  _settings.pFlag = false;
                  _settings.rFlag = false;
                  _settings.coolingCoefficientCurrent = 0.350;
                  _settings.currentLocale = _dropdownValue = _locales.first;

                  _coolingCoefficientLimitFlag = true;
                  _coefficientCtrl.text = _settings.coolingCoefficientCurrent.toString();
                  _dropdownKey.currentState!.reset();
                });
              },
              label: _settings.locale.defaults.isEmpty
                  ? const Text('Defaults')
                  : Text(_settings.locale.defaults),
            ),
          ),
          //
          // Apply current app settings.
          //
          SizedBox(
            width: 128,
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
              label: _settings.locale.apply.isEmpty
                  ? const Text('Apply')
                  : Text(_settings.locale.apply),
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
      _dropdownValue = widget.settings.currentLocale;
    });
  }

  @override
  void dispose() {
    _coefficientCtrl.dispose();
    super.dispose();
  }

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
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: _settings.locale.general.isEmpty
                  ? const Text(
                      'General',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      _settings.locale.general,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: getLanguageChanger(),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: getPrecisionCheckbox(),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: getRoundingCheckbox(),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: getStandardCheckbox(),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: 128,
                child: getWattsField(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: getControlPanel(context),
    );
  }
}
