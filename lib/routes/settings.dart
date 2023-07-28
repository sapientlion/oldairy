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
                value: _settings.isOldStandardEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    if (!_settings.isOldStandardEnabled) {
                      _settings.isOldStandardEnabled = true;
                    } else {
                      _settings.isOldStandardEnabled = false;
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
                              _settings.isOldStandardEnabled = false;
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
