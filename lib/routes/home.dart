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

import 'package:oldairy/classes/calculator.dart';
import 'package:oldairy/classes/settings.dart';
import 'package:oldairy/classes/tformatter.dart';
import 'package:oldairy/routes/about.dart';
import 'package:oldairy/routes/settings.dart';

class Oldairy extends StatelessWidget {
  const Oldairy({super.key});

  final String _appTitle = 'Oldairy';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeRoute(
        title: _appTitle,
      ),
    );
  }
}

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key, required this.title});

  final String title;

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  bool _azFlag = false; // Absolute zero flag.
  final int _initTempLimit = 50;
  final int _volumeLimit = 30000;
  final int _ampsLimit = 125;
  final double _initValue = 0.0;
  final double _absoluteZero = -273.15;
  final double _setTempLimit = -273.15;
  final Calculator _calculator = Calculator(
    initialTemp: 0.0,
    setTemp: 0.0,
    volume: 0.0,
    voltage: 230.0,
    ampsFirstWire: 0.0,
    ampsSecondWire: 0.0,
    ampsThirdWire: 0.0,
  );
  final TextEditingController _initTempCtrl = TextEditingController();
  final TextEditingController _setTempCtrl = TextEditingController();
  final TextEditingController _volumeCtrl = TextEditingController();
  final TextEditingController _ampsFirstWireCtrl = TextEditingController();
  final TextEditingController _ampsSecondWireCtrl = TextEditingController();
  final TextEditingController _ampsThirdWireCtrl = TextEditingController();

  bool _swaFlag = false; // Second wire availability flag.
  bool _twaFlag = false; // Third wire availability flag.
  int _dropdownValue = 0; // Current dropdown button value.
  String _coolingTimeHours = '0'; // Cooling time: hours.
  String _coolingTimeMinutes = '0'; // Cooling time: minutes.
  TimeFormatter timeFormatter = TimeFormatter(
      calculator: Calculator(
    initialTemp: 0.0,
    setTemp: 0.0,
    volume: 0.0,
    voltage: 0.0,
    ampsFirstWire: 0.0,
    ampsSecondWire: 0.0,
    ampsThirdWire: 0.0,
  ));
  Settings _settings = Settings(); // General app settings.
  List<int> _voltages = <int>[230, 400]; // Store ISO-approved voltages here.

  _HomeRouteState() {
    _initTempCtrl.text = _initValue.toString();
    _setTempCtrl.text = _initValue.toString();
    _volumeCtrl.text = _initValue.toString();
    _ampsFirstWireCtrl.text = _initValue.toString();
    _ampsSecondWireCtrl.text = _initValue.toString();
    _ampsThirdWireCtrl.text = _initValue.toString();

    _dropdownValue = _voltages.first;
  }

  //
  // React to popup menu button presses.
  //
  void doPopupAction(int value) async {
    switch (value) {
      //
      // Open the settings route.
      //
      case 1:
        {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsRoute(
                title: widget.title,
                settings: _settings,
              ),
            ),
          );

          setState(() {
            _settings = result;

            //
            // Switch voltage standards.
            //
            if (!_settings.osFlag) {
              _voltages = <int>[230, 400];
            } else {
              _voltages = <int>[220, 230, 380, 400];
            }
          });

          switchLocale(_settings.currentLocale);

          return;
        }
      //
      // Terminate the application.
      //
      case 2:
        {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutRoute(
                title: widget.title,
              ),
            ),
          );

          return;
        }
      //
      // Exit app.
      //
      case 3:
        {
          SystemNavigator.pop();

          return;
        }
    }

    return;
  }

  PopupMenuButton<int> getPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 1,
            child: _settings.locale.settings.isEmpty ? const Text("Settings") : Text(_settings.locale.settings),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: _settings.locale.about.isEmpty ? const Text("About") : Text(_settings.locale.about),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: _settings.locale.exit.isEmpty ? const Text("Exit") : Text(_settings.locale.exit),
          ),
        ];
      },
      onSelected: (value) async {
        doPopupAction(value);
      },
    );
  }

  Wrap getTempOutput() {
    return Wrap(
      children: [
        _settings.locale.hours.isEmpty
            ? Text(
                '$_coolingTimeHours h. ',
                textScaleFactor: 4,
              ) // Trailing space is intentional. Do not remove!
            : Text(
                '$_coolingTimeHours ${_settings.locale.hours}',
                textScaleFactor: 4,
              ),
        _settings.locale.minutes.isEmpty
            ? Text(
                '$_coolingTimeMinutes m.',
                textScaleFactor: 4,
              )
            : Text(
                '$_coolingTimeMinutes ${_settings.locale.minutes}',
                textScaleFactor: 4,
              ),
        //
        // Nothing to see here...
        //
        _azFlag && _settings.osFlag
            ? const Text(
                '\u{1f480}',
                textScaleFactor: 4,
              )
            : const Text(''),
      ],
    );
  }

  FloatingActionButton getClearAllButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        setState(() {
          _coolingTimeHours = '0';
          _coolingTimeMinutes = '0';
        });

        purge(_calculator);
      },
      label: _settings.locale.clearAll.isEmpty ? const Text('Clear All') : Text(_settings.locale.clearAll),
    );
  }

  DropdownButtonFormField<int> getVoltageDropdown() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 1),
        label: Center(
          child: _settings.locale.voltage.isEmpty ? const Text('Voltage') : Text(_settings.locale.voltage),
        ),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      value: _dropdownValue,
      items: _voltages.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (int? value) {
        // This is called when the user selects an item.
        setState(() {
          _dropdownValue = value!;
          _calculator.voltage = value.toDouble();

          if (_calculator.voltage >= 220 && _calculator.voltage <= 230) {
            _swaFlag = false;
            _twaFlag = false;
          } else {
            _swaFlag = true;
            _twaFlag = true;
          }

          _calculator.initialTemp = double.parse(_initTempCtrl.text);
          _calculator.setTemp = double.parse(_setTempCtrl.text);
          _calculator.volume = double.parse(_volumeCtrl.text);
          _calculator.ampsFirstWire = double.parse(_ampsFirstWireCtrl.text);
          _calculator.ampsSecondWire = double.parse(_ampsSecondWireCtrl.text);
          _calculator.ampsThirdWire = double.parse(_ampsThirdWireCtrl.text);

          _calculator.cCoefficient = _settings.cCoefficient;
          _calculator.calculate();

          timeFormatter.calculator = _calculator;

          _coolingTimeHours = timeFormatter.getHours().toString();
          _coolingTimeMinutes = timeFormatter
              .getMinutes(
                rFlag: _settings.rFlag,
                pFlag: _settings.pFlag,
              )
              .toString();
        });
      },
    );
  }

  TextFormField getFirstWireField() {
    return TextFormField(
      autocorrect: false,
      controller: _ampsFirstWireCtrl,
      decoration: InputDecoration(
        counterStyle: const TextStyle(height: double.minPositive),
        counterText: '',
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 1),
        label: Center(
          child:
              _settings.locale.ampsFirstWire.isEmpty ? const Text('Amperage 1') : Text(_settings.locale.ampsFirstWire),
        ),
      ),
      keyboardType: TextInputType.number,
      maxLength: 3,
      onChanged: (value) {
        setState(() {
          if (_ampsFirstWireCtrl.value.text.isEmpty) {
            _ampsFirstWireCtrl.text = _initValue.toString();
            _ampsFirstWireCtrl.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _ampsFirstWireCtrl.value.text.length,
            );
          }

          //
          // Input field can't be empty. Prevent that by doing the following.
          //
          if (double.tryParse(value) == null) {
            _calculator.ampsFirstWire = _initValue;
          } else {
            _calculator.ampsFirstWire = double.parse(value);
          }

          if (_calculator.ampsFirstWire > _ampsLimit) {
            //
            // Set member value to pre-defined amperage limit.
            //
            _calculator.ampsFirstWire = _ampsLimit.toDouble();
            //
            // Assign a new value to the input field.
            //
            _ampsFirstWireCtrl.text = _calculator.ampsFirstWire.toString();
          }

          _calculator.cCoefficient = _settings.cCoefficient;
          _calculator.calculate();

          timeFormatter.calculator = _calculator;

          _coolingTimeHours = timeFormatter.getHours().toString();
          _coolingTimeMinutes = timeFormatter
              .getMinutes(
                rFlag: _settings.rFlag,
                pFlag: _settings.pFlag,
              )
              .toString();
        });
      },
      onTap: () {
        _ampsFirstWireCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ampsFirstWireCtrl.value.text.length,
        );
      },
      style: const TextStyle(
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  }

  TextFormField getSecondWireField() {
    return TextFormField(
      autocorrect: false,
      controller: _ampsSecondWireCtrl,
      decoration: !_swaFlag
          ? InputDecoration(
              counterStyle: const TextStyle(
                height: double.minPositive,
              ),
              counterText: '',
              filled: true,
              fillColor: const Color.fromRGBO(211, 211, 211, 0),
              label: Center(
                child: _settings.locale.ampsSecondWire.isEmpty
                    ? const Text('Amperage 2')
                    : Text(_settings.locale.ampsSecondWire),
              ),
              labelStyle: const TextStyle(
                color: Color.fromRGBO(211, 211, 211, 0),
              ),
            )
          : InputDecoration(
              counterStyle: const TextStyle(
                height: double.minPositive,
              ),
              counterText: '',
              filled: true,
              fillColor: const Color.fromRGBO(211, 211, 211, 1),
              label: Center(
                child: _settings.locale.ampsSecondWire.isEmpty
                    ? const Text('Amperage 2')
                    : Text(_settings.locale.ampsSecondWire),
              ),
            ),
      enabled: _swaFlag,
      keyboardType: TextInputType.number,
      maxLength: 3,
      onChanged: (value) {
        setState(() {
          if (_ampsSecondWireCtrl.text.isEmpty) {
            _ampsSecondWireCtrl.text = _initValue.toString();
            _ampsSecondWireCtrl.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _ampsSecondWireCtrl.value.text.length,
            );
          }

          if (double.tryParse(value) == null) {
            _calculator.ampsSecondWire = _initValue;
          } else {
            _calculator.ampsSecondWire = double.parse(value);
          }

          if (_calculator.ampsSecondWire > _ampsLimit) {
            _calculator.ampsSecondWire = _ampsLimit.toDouble();
            _ampsSecondWireCtrl.text = _calculator.ampsSecondWire.toString();
          }

          _calculator.cCoefficient = _settings.cCoefficient;
          _calculator.calculate();

          timeFormatter.calculator = _calculator;

          _coolingTimeHours = timeFormatter.getHours().toString();
          _coolingTimeMinutes = timeFormatter
              .getMinutes(
                rFlag: _settings.rFlag,
                pFlag: _settings.pFlag,
              )
              .toString();
        });
      },
      onTap: () {
        _ampsSecondWireCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ampsSecondWireCtrl.value.text.length,
        );
      },
      style: !_swaFlag
          ? const TextStyle(
              color: Color.fromRGBO(211, 211, 211, 0),
              fontSize: 20,
            )
          : const TextStyle(
              fontSize: 20,
            ),
      textAlign: TextAlign.center,
    );
  }

  TextFormField getThirdWireField() {
    return TextFormField(
      autocorrect: false,
      controller: _ampsThirdWireCtrl,
      decoration: !_twaFlag
          ? InputDecoration(
              counterStyle: const TextStyle(
                height: double.minPositive,
              ),
              counterText: '',
              filled: true,
              fillColor: Colors.white10,
              label: Center(
                child: _settings.locale.ampsThirdWire.isEmpty
                    ? const Text('Amperage 3')
                    : Text(_settings.locale.ampsThirdWire),
              ),
              labelStyle: const TextStyle(
                color: Color.fromRGBO(211, 211, 211, 0),
              ),
            )
          : InputDecoration(
              counterStyle: const TextStyle(
                height: double.minPositive,
              ),
              counterText: '',
              filled: true,
              fillColor: const Color.fromRGBO(211, 211, 211, 1),
              label: Center(
                child: _settings.locale.ampsThirdWire.isEmpty
                    ? const Text('Amperage 3')
                    : Text(_settings.locale.ampsThirdWire),
              ),
            ),
      enabled: _twaFlag,
      keyboardType: TextInputType.number,
      maxLength: 3,
      onChanged: (value) {
        setState(() {
          if (_ampsThirdWireCtrl.text.isEmpty) {
            _ampsThirdWireCtrl.text = _initValue.toString();
            _ampsThirdWireCtrl.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _ampsThirdWireCtrl.value.text.length,
            );
          }

          if (double.tryParse(value) == null) {
            _calculator.ampsThirdWire = _initValue;
          } else {
            _calculator.ampsThirdWire = double.parse(value);
          }

          if (_calculator.ampsThirdWire > _ampsLimit) {
            _calculator.ampsThirdWire = _ampsLimit.toDouble();
            _ampsThirdWireCtrl.text = _calculator.ampsThirdWire.toString();
          }

          _calculator.cCoefficient = _settings.cCoefficient;
          _calculator.calculate();

          timeFormatter.calculator = _calculator;

          _coolingTimeHours = timeFormatter.getHours().toString();
          _coolingTimeMinutes = timeFormatter
              .getMinutes(
                rFlag: _settings.rFlag,
                pFlag: _settings.pFlag,
              )
              .toString();
        });
      },
      onTap: () {
        _ampsThirdWireCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ampsThirdWireCtrl.value.text.length,
        );
      },
      style: !_twaFlag
          ? const TextStyle(
              color: Color.fromRGBO(211, 211, 211, 0),
              fontSize: 20,
            )
          : const TextStyle(
              fontSize: 20,
            ),
      textAlign: TextAlign.center,
    );
  }

  TextFormField getInitTempField() {
    return TextFormField(
      autocorrect: false,
      controller: _initTempCtrl,
      //
      // Get rid of the counter; do the same thing for
      // the other fields as well.
      //
      decoration: InputDecoration(
        counterStyle: const TextStyle(
          height: double.minPositive,
        ),
        counterText: '',
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 1),
        label: Center(
          child: _settings.locale.initialTemp.isEmpty ? const Text('Initial Temp') : Text(_settings.locale.initialTemp),
        ),
      ),
      style: const TextStyle(
        fontSize: 20,
      ),
      keyboardType: TextInputType.number,
      maxLength: 8,
      onChanged: (value) {
        setState(() {
          if (_initTempCtrl.text.isEmpty) {
            _initTempCtrl.text = _initValue.toString();
            _initTempCtrl.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _initTempCtrl.value.text.length,
            );
          }

          if (double.tryParse(value) == null) {
            _calculator.initialTemp = _initValue;
          } else {
            _calculator.initialTemp = double.parse(value);
          }

          if (_calculator.initialTemp > _initTempLimit || _calculator.initialTemp < 0) {
            _calculator.initialTemp = _initTempLimit.toDouble();
            _initTempCtrl.text = _calculator.initialTemp.toString();
          }

          _calculator.cCoefficient = _settings.cCoefficient;
          _calculator.calculate();

          timeFormatter.calculator = _calculator;

          _coolingTimeHours = timeFormatter.getHours().toString();
          _coolingTimeMinutes = timeFormatter
              .getMinutes(
                rFlag: _settings.rFlag,
                pFlag: _settings.pFlag,
              )
              .toString();
        });
      },
      onTap: () {
        _initTempCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _initTempCtrl.value.text.length,
        );
      },
      textAlign: TextAlign.center,
    );
  }

  TextFormField getSetTempField() {
    return TextFormField(
      autocorrect: false,
      controller: _setTempCtrl,
      decoration: InputDecoration(
        counterStyle: const TextStyle(height: double.minPositive),
        counterText: '',
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 1),
        label: Center(
          child: _settings.locale.setTemp.isEmpty ? const Text('Set Temp') : Text(_settings.locale.setTemp),
        ),
      ),
      keyboardType: TextInputType.number,
      maxLength: 8,
      onChanged: (value) {
        setState(() {
          if (_setTempCtrl.text.isEmpty) {
            _setTempCtrl.text = _initValue.toString();
            _setTempCtrl.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _setTempCtrl.value.text.length,
            );
          }

          if (double.tryParse(value) == null) {
            _calculator.setTemp = _initValue;
          } else {
            _calculator.setTemp = double.parse(value);
          }

          //
          // Check whether set temperature is equal to an absolute zero.
          //
          if (_calculator.setTemp == _absoluteZero) {
            setState(() {
              _azFlag = true;
            });
          } else {
            setState(() {
              _azFlag = false;
            });
          }

          if (!_azFlag && _calculator.setTemp <= _setTempLimit || _calculator.setTemp > _initTempLimit) {
            _calculator.setTemp = -50.0;
            _setTempCtrl.text = _calculator.setTemp.toString();
          }

          _calculator.cCoefficient = _settings.cCoefficient;
          _calculator.calculate();

          timeFormatter.calculator = _calculator;

          _coolingTimeHours = timeFormatter.getHours().toString();
          _coolingTimeMinutes = timeFormatter
              .getMinutes(
                rFlag: _settings.rFlag,
                pFlag: _settings.pFlag,
              )
              .toString();
        });
      },
      onTap: () {
        _setTempCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _setTempCtrl.value.text.length,
        );
      },
      style: const TextStyle(
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  }

  TextFormField getVolumeField() {
    return TextFormField(
      autocorrect: false,
      controller: _volumeCtrl,
      decoration: InputDecoration(
        counterStyle: const TextStyle(height: double.minPositive),
        counterText: '',
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 1),
        label: Center(
          child: _settings.locale.volume.isEmpty ? const Text('Volume') : Text(_settings.locale.volume),
        ),
      ),
      keyboardType: TextInputType.number,
      maxLength: 5,
      onChanged: (value) {
        setState(() {
          if (_volumeCtrl.text.isEmpty) {
            _volumeCtrl.text = _initValue.toString();
            _volumeCtrl.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _volumeCtrl.value.text.length,
            );
          }

          if (double.tryParse(value) == null) {
            _calculator.volume = _initValue;
          } else {
            _calculator.volume = double.parse(value);
          }

          if (_calculator.volume > _volumeLimit) {
            _calculator.volume = _volumeLimit.toDouble();
            _volumeCtrl.text = _calculator.volume.toString();
          }

          _calculator.cCoefficient = _settings.cCoefficient;
          _calculator.calculate();

          timeFormatter.calculator = _calculator;

          _coolingTimeHours = timeFormatter.getHours().toString();
          _coolingTimeMinutes = timeFormatter
              .getMinutes(
                rFlag: _settings.rFlag,
                pFlag: _settings.pFlag,
              )
              .toString();
        });
      },
      onTap: () {
        _volumeCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _volumeCtrl.value.text.length,
        );
      },
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );
  }

  @override
  void initState() {
    super.initState();

    _settings.read().then((value) {
      setState(() {
        bool lFlag = true;
        Map<String, dynamic> json = jsonDecode(value);

        //
        // Load app settings from a map.
        //
        _settings.osFlag = json['isOldStandardEnabled'];
        _settings.rFlag = json['isTimeRoundingEnabled'];
        _settings.pFlag = json['areAbsoluteValuesAllowed'];
        _settings.cCoefficient = json['coefficient'];
        _settings.currentLocale = json['currentLocale'];
        _settings.localeName = json['localeFile'];

        readLocale(_settings.localeName).then((value) {
          lFlag = value;
        });

        //
        // Requested locale may be absent from the disk.
        //
        if (!lFlag) {
          readDefaultLocale();
        }
      });
    });
  }

  @override
  void dispose() {
    _initTempCtrl.dispose();
    _setTempCtrl.dispose();
    _volumeCtrl.dispose();
    _ampsFirstWireCtrl.dispose();
    _ampsSecondWireCtrl.dispose();
    _ampsThirdWireCtrl.dispose();
    super.dispose();
  }

  //
  // Get a default locale from a file.
  //
  Future<void> readDefaultLocale() async {
    String response = '';

    try {
      response = await rootBundle.loadString('assets/locales/en_us.json');
    } catch (e) {
      return;
    }

    final data = await json.decode(response);
    Map<String, dynamic> locale = data;

    setState(() {
      _settings.locale.hours = locale['hours'];
      _settings.locale.minutes = locale['minutes'];
      _settings.locale.initialTemp = locale['initialTemp'];
      _settings.locale.setTemp = locale['setTemp'];
      _settings.locale.volume = locale['volume'];
      _settings.locale.voltage = locale['voltage'];
      _settings.locale.ampsFirstWire = locale['ampFirst'];
      _settings.locale.ampsSecondWire = locale['ampSecond'];
      _settings.locale.ampsThirdWire = locale['ampThird'];
      _settings.locale.clearAll = locale['clearAll'];
      _settings.locale.settings = locale['settings'];
      _settings.locale.about = locale['about'];
      _settings.locale.help = locale['help'];
      _settings.locale.exit = locale['exit'];
      _settings.locale.general = locale['general'];
      _settings.locale.language = locale['language'];
      _settings.locale.oldStandardSupport = locale['oldStandard'];
      _settings.locale.defaults = locale['defaults'];
      _settings.locale.apply = locale['apply'];
    });

    return;
  }

  //
  // Get specific locale from a file.
  //
  Future<bool> readLocale(String name) async {
    String response = '';

    try {
      response = await rootBundle.loadString('assets/locales/$name');
    } catch (e) {
      return false;
    }

    final data = await json.decode(response);
    Map<String, dynamic> locale = data;

    setState(() {
      _settings.locale.hours = locale['hours'];
      _settings.locale.minutes = locale['minutes'];
      _settings.locale.initialTemp = locale['initialTemp'];
      _settings.locale.setTemp = locale['setTemp'];
      _settings.locale.volume = locale['volume'];
      _settings.locale.voltage = locale['voltage'];
      _settings.locale.ampsFirstWire = locale['ampFirst'];
      _settings.locale.ampsSecondWire = locale['ampSecond'];
      _settings.locale.ampsThirdWire = locale['ampThird'];
      _settings.locale.clearAll = locale['clearAll'];
      _settings.locale.settings = locale['settings'];
      _settings.locale.about = locale['about'];
      _settings.locale.help = locale['help'];
      _settings.locale.exit = locale['exit'];
      _settings.locale.general = locale['general'];
      _settings.locale.language = locale['language'];
      _settings.locale.oldStandardSupport = locale['oldStandard'];
      _settings.locale.defaults = locale['defaults'];
      _settings.locale.apply = locale['apply'];
    });

    return true;
  }

  //
  // Switch GUI's language to specific locale.
  //
  //
  // TODO find another way for storing locale names and locale file names.
  //
  String switchLocale(String locale) {
    switch (locale) {
      case 'Serbian (Cyrillic)':
        {
          _settings.localeName = 'rs_cyrillic.json';

          readLocale(_settings.localeName);

          break;
        }
      case 'Serbian (Latin)':
        {
          _settings.localeName = 'rs_latin.json';

          readLocale(_settings.localeName);

          break;
        }
      case 'Swedish':
        {
          _settings.localeName = 'sv_se.json';

          readLocale(_settings.localeName);

          break;
        }
      default:
        {
          _settings.localeName = 'en_us.json';

          readDefaultLocale();

          break;
        }
    }

    return locale;
  }

  //
  // Purge all fields from data.
  //
  Calculator purge(Calculator calculator) {
    _calculator.initialTemp = 0.0;
    _calculator.setTemp = 0.0;
    _calculator.volume = 0.0;
    _calculator.ampsFirstWire = 0.0;
    _calculator.ampsSecondWire = 0.0;
    _calculator.ampsThirdWire = 0.0;

    _initTempCtrl.text = _initValue.toString();
    _setTempCtrl.text = _initValue.toString();
    _volumeCtrl.text = _initValue.toString();
    _ampsFirstWireCtrl.text = _initValue.toString();
    _ampsSecondWireCtrl.text = _initValue.toString();
    _ampsThirdWireCtrl.text = _initValue.toString();

    return calculator;
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
      body: Center(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getTempOutput(),
                    const Padding(
                      padding: EdgeInsets.all(16),
                    ),
                    getClearAllButton(),
                    const Padding(
                      padding: EdgeInsets.all(16),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 32,
                      spacing: 32,
                      children: [
                        SizedBox(
                          width: 128,
                          child: getVoltageDropdown(),
                        ),
                        SizedBox(
                          width: 128,
                          child: getFirstWireField(),
                        ),
                        SizedBox(
                          width: 128,
                          child: getSecondWireField(),
                        ),
                        SizedBox(
                          width: 128,
                          child: getThirdWireField(),
                        ),
                        SizedBox(
                          width: 128,
                          child: getInitTempField(),
                        ),
                        SizedBox(
                          width: 128,
                          child: getSetTempField(),
                        ),
                        SizedBox(
                          width: 128,
                          child: getVolumeField(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
