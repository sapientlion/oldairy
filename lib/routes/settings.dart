import 'package:flutter/material.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({super.key, required this.title});

  final String title;

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

  _SettingsRouteState() {
    _dropdownValue = _languages.first;
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(32),
              child: CheckboxListTile(
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Enable 220V/380V Support'),
                //fillColor: MaterialStateProperty.resolveWith(getColor),
                value: false,
                onChanged: (bool? value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
