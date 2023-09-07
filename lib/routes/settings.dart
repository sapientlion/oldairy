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

	Description: the settings route.

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
  final List<String> _locales = <String>[
    'English (US)',
    'Serbian (Cyrillic)',
    'Serbian (Latin)',
    'Swedish',
  ];

  String _dropdownValue = '';
  Settings _settings = Settings();

  @override
  void initState() {
    super.initState();

    setState(() {
      _settings = widget.settings;
      _dropdownValue = widget.settings.currentLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    _settings = widget.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: _settings.locale.general.isEmpty
                  ? const Text(
                      'General',
                      textScaleFactor: 2,
                    )
                  : Text(
                      _settings.locale.general,
                      textScaleFactor: 2,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: DropdownButtonFormField<String>(
                key: _dropdownKey,
                decoration: InputDecoration(
                  label: _settings.locale.language.isEmpty ? const Text('Language') : Text(_settings.locale.language),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
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
              ),
            ),
            //
            // More precise minutes setting.
            //
            Padding(
              padding: const EdgeInsets.all(32),
              child: CheckboxListTile(
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
              ),
            ),
            //
            // Time rounding setting.
            //
            Padding(
              padding: const EdgeInsets.all(32),
              child: CheckboxListTile(
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
              ),
            ),
            //
            // Support previous ISO standard via checkbox interaction.
            //
            Padding(
              padding: const EdgeInsets.all(32),
              child: CheckboxListTile(
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 32,
                    children: [
                      //
                      // Reset all settings to their default values.
                      //
                      SizedBox(
                        width: 128,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            setState(() {
                              _settings.osFlag = false;
                              _settings.pFlag = false;
                              _settings.rFlag = false;
                              _settings.currentLocale = _dropdownValue = _locales.first;

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
                          onPressed: () {
                            _settings.write(_settings);
                            Navigator.pop(context, _settings);
                          },
                          label: _settings.locale.apply.isEmpty ? const Text('Apply') : Text(_settings.locale.apply),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
