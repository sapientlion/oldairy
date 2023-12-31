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

  bool _swaFlag = false; // Second wire availability flag.
  bool _twaFlag = false; // Third wire availability flag.
  int _dropdownValue = 0; // Current dropdown button value.
  String _coolingTimeHours = '0'; // Cooling time: hours.
  String _coolingTimeMinutes = '0'; // Cooling time: minutes.
  Settings _settings = Settings(); // General app settings.
  TextEditingController _initTempCtrl = TextEditingController();
  TextEditingController _setTempCtrl = TextEditingController();
  TextEditingController _volumeCtrl = TextEditingController();
  TextEditingController _ampsFirstWireCtrl = TextEditingController();
  TextEditingController _ampsSecondWireCtrl = TextEditingController();
  TextEditingController _ampsThirdWireCtrl = TextEditingController();
  List<int> _voltages = <int>[230, 400]; // Store ISO-approved voltages here.

  TimeFormatter _timeFormatter = TimeFormatter(
      calculator: Calculator(
    initialTemp: 0.0,
    setTemp: 0.0,
    volume: 0.0,
    voltage: 0.0,
    ampsFirstWire: 0.0,
    ampsSecondWire: 0.0,
    ampsThirdWire: 0.0,
  ));

  _HomeRouteState() {
    _dropdownValue = _voltages.first;

    _initTempCtrl.text = _initValue.toString();
    _setTempCtrl.text = _initValue.toString();
    _volumeCtrl.text = _initValue.toString();
    _ampsFirstWireCtrl.text = _initValue.toString();
    _ampsSecondWireCtrl.text = _initValue.toString();
    _ampsThirdWireCtrl.text = _initValue.toString();

    //
    // Don't forget to initialize the voltage located inside of the calculator object.
    //
    _timeFormatter.calculator.voltage = _voltages.first.toDouble();
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
          });

          switchLocale(_settings.currentLocale);

          //
          // Do calculate after applying the app settings.
          //
          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();

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

  //
  // Set cooling time hours and minutes.
  //
  void set() {
    _coolingTimeHours = _timeFormatter.getHours().toString();
    _coolingTimeMinutes = _timeFormatter
        .getMinutes(
          rFlag: _settings.rFlag,
          pFlag: _settings.pFlag,
        )
        .toString();

    return;
  }

  //
  // Re-initialize `TextEditingController` if empty.
  //
  TextEditingController reset(TextEditingController controller) {
    if (controller.value.text.isEmpty) {
      controller.text = _initValue.toString();
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.value.text.length,
      );
    }

    return controller;
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ) // Trailing space is intentional. Do not remove!
            : Text(
                '$_coolingTimeHours ${_settings.locale.hours}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        _settings.locale.minutes.isEmpty
            ? Text(
                '$_coolingTimeMinutes m.',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                '$_coolingTimeMinutes ${_settings.locale.minutes}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        //
        // Nothing to see here...
        //
        _azFlag && _settings.osFlag
            ? const Text(
                '\u{1f480}',
                style: TextStyle(
                  fontSize: 24,
                ),
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

        purge(_timeFormatter.calculator);
      },
      label: _settings.locale.clearAll.isEmpty ? const Text('Clear All') : Text(_settings.locale.clearAll),
    );
  }

  DropdownButtonFormField<int> getVoltageDropdown() {
    //
    // Check for the currently set voltages standard. Also, do this to prevent app from crashing due to the missing
    // values.
    //
    if (!_settings.osFlag) {
      _voltages = <int>[230, 400];
      _dropdownValue = _voltages.first;
    } else {
      _voltages = <int>[220, 230, 380, 400];
    }

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 1),
        label: Center(
          child: _settings.locale.voltage.isEmpty ? const Text('Voltage') : Text(_settings.locale.voltage),
        ),
        /*labelStyle: const TextStyle(
          fontSize: 20,
        ),*/
      ),
      style: const TextStyle(
        color: Colors.black,
        //fontSize: 20,
      ),
      value: _dropdownValue,
      items: _voltages.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (int? value) {
        //
        // This is called when the user selects an item.
        //
        setState(() {
          _dropdownValue = value!;
          _timeFormatter.calculator.voltage = value.toDouble();

          if (_timeFormatter.calculator.voltage >= 220 && _timeFormatter.calculator.voltage <= 230) {
            _swaFlag = false;
            _twaFlag = false;
          } else {
            _swaFlag = true;
            _twaFlag = true;
          }

          _timeFormatter.calculator.initialTemp = double.parse(_initTempCtrl.text);
          _timeFormatter.calculator.setTemp = double.parse(_setTempCtrl.text);
          _timeFormatter.calculator.volume = double.parse(_volumeCtrl.text);
          _timeFormatter.calculator.ampsFirstWire = double.parse(_ampsFirstWireCtrl.text);
          _timeFormatter.calculator.ampsSecondWire = double.parse(_ampsSecondWireCtrl.text);
          _timeFormatter.calculator.ampsThirdWire = double.parse(_ampsThirdWireCtrl.text);

          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();
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
          _ampsFirstWireCtrl = reset(_ampsFirstWireCtrl);

          //
          // Input field can't be empty. Prevent that by doing the following.
          //
          if (double.tryParse(value) == null) {
            _timeFormatter.calculator.ampsFirstWire = _initValue;
          } else {
            _timeFormatter.calculator.ampsFirstWire = double.parse(value);
          }

          if (_timeFormatter.calculator.ampsFirstWire > _ampsLimit) {
            //
            // Set member value to pre-defined amperage limit.
            //
            _timeFormatter.calculator.ampsFirstWire = _ampsLimit.toDouble();
            //
            // Assign a new value to the input field.
            //
            _ampsFirstWireCtrl.text = _timeFormatter.calculator.ampsFirstWire.toString();
          }

          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();
        });
      },
      onTap: () {
        _ampsFirstWireCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ampsFirstWireCtrl.value.text.length,
        );
      },
      /*style: const TextStyle(
        fontSize: 20,
      ),*/
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
          _ampsSecondWireCtrl = reset(_ampsSecondWireCtrl);

          if (double.tryParse(value) == null) {
            _timeFormatter.calculator.ampsSecondWire = _initValue;
          } else {
            _timeFormatter.calculator.ampsSecondWire = double.parse(value);
          }

          if (_timeFormatter.calculator.ampsSecondWire > _ampsLimit) {
            _timeFormatter.calculator.ampsSecondWire = _ampsLimit.toDouble();
            _ampsSecondWireCtrl.text = _timeFormatter.calculator.ampsSecondWire.toString();
          }

          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();
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
              //fontSize: 20,
            )
          : const TextStyle(
              //fontSize: 20,
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
          _ampsThirdWireCtrl = reset(_ampsThirdWireCtrl);

          if (double.tryParse(value) == null) {
            _timeFormatter.calculator.ampsThirdWire = _initValue;
          } else {
            _timeFormatter.calculator.ampsThirdWire = double.parse(value);
          }

          if (_timeFormatter.calculator.ampsThirdWire > _ampsLimit) {
            _timeFormatter.calculator.ampsThirdWire = _ampsLimit.toDouble();
            _ampsThirdWireCtrl.text = _timeFormatter.calculator.ampsThirdWire.toString();
          }

          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();
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
              //fontSize: 20,
            )
          : const TextStyle(
              //fontSize: 20,
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
      /*style: const TextStyle(
        fontSize: 20,
      ),*/
      keyboardType: TextInputType.number,
      maxLength: 8,
      onChanged: (value) {
        setState(() {
          _initTempCtrl = reset(_initTempCtrl);

          if (double.tryParse(value) == null) {
            _timeFormatter.calculator.initialTemp = _initValue;
          } else {
            _timeFormatter.calculator.initialTemp = double.parse(value);
          }

          if (_timeFormatter.calculator.initialTemp > _initTempLimit || _timeFormatter.calculator.initialTemp < 0) {
            _timeFormatter.calculator.initialTemp = _initTempLimit.toDouble();
            _initTempCtrl.text = _timeFormatter.calculator.initialTemp.toString();
          }

          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();
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
          _setTempCtrl = reset(_setTempCtrl);

          if (double.tryParse(value) == null) {
            _timeFormatter.calculator.setTemp = _initValue;
          } else {
            _timeFormatter.calculator.setTemp = double.parse(value);
          }

          //
          // Check whether set temperature is equal to an absolute zero.
          //
          if (_timeFormatter.calculator.setTemp == _absoluteZero) {
            setState(() {
              _azFlag = true;
            });
          } else {
            setState(() {
              _azFlag = false;
            });
          }

          if (!_azFlag && _timeFormatter.calculator.setTemp <= _setTempLimit ||
              _timeFormatter.calculator.setTemp > _initTempLimit) {
            _timeFormatter.calculator.setTemp = -50.0;
            _setTempCtrl.text = _timeFormatter.calculator.setTemp.toString();
          }

          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();
        });
      },
      onTap: () {
        _setTempCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _setTempCtrl.value.text.length,
        );
      },
      /*style: const TextStyle(
        fontSize: 20,
      ),*/
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
          _volumeCtrl = reset(_volumeCtrl);

          if (double.tryParse(value) == null) {
            _timeFormatter.calculator.volume = _initValue;
          } else {
            _timeFormatter.calculator.volume = double.parse(value);
          }

          if (_timeFormatter.calculator.volume > _volumeLimit) {
            _timeFormatter.calculator.volume = _volumeLimit.toDouble();
            _volumeCtrl.text = _timeFormatter.calculator.volume.toString();
          }

          _timeFormatter.calculator.kWatts = _settings.cCoefficient;
          _timeFormatter.calculator.calculate();

          set();
        });
      },
      onTap: () {
        _volumeCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _volumeCtrl.value.text.length,
        );
      },
      /*style: const TextStyle(
        fontSize: 20,
      ),*/
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
          readLocale('en_us.json');
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

          readLocale(_settings.localeName);

          break;
        }
    }

    return locale;
  }

  //
  // Purge all fields from data.
  //
  Calculator purge(Calculator calculator) {
    _timeFormatter = TimeFormatter(
        calculator: Calculator(
            initialTemp: 0.0,
            setTemp: 0.0,
            volume: 0.0,
            voltage: _dropdownValue.toDouble(),
            ampsFirstWire: 0.0,
            ampsSecondWire: 0.0,
            ampsThirdWire: 0.0));

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
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8.0,
        child: Center(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            child: Column(
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
      ),
    );
  }
}
