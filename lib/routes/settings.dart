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
  final List<String> _languages = <String>[
    'English (US)',
    'Serbian (Cyrillic)',
    'Serbian (Latin)',
  ];

  String _dropdownValue = '';
  Settings _settings = Settings();

  _SettingsRouteState() {
    _dropdownValue = _languages.first;
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
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'General',
                textScaleFactor: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  label: Text('Language'),
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                value: _dropdownValue,
                items: _languages.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {});
                },
              ),
            ),
            //
            // Support previous standard via checkbox interaction.
            //
            Padding(
              padding: const EdgeInsets.all(32),
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                tileColor: const Color.fromRGBO(211, 211, 211, 0),
                title: const Text('Enable 220V/380V Support'),
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
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context, _settings);
                },
                label: const Text('Apply'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
