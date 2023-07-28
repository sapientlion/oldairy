import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:oldairy/classes/calculator.dart';
import 'package:oldairy/classes/settings.dart';
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
  final int _initialTempLimit = 50;
  final int _setTempLimit = -50;
  final int _volumeLimit = 30000;
  final int _amperageLimit = 125;
  final double _initialValue = 0.0;
  final Calculator _calculator = Calculator();
  final TextEditingController _initialTempController = TextEditingController();
  final TextEditingController _setTempController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _ampFirstWireController = TextEditingController();
  final TextEditingController _ampSecondWireController = TextEditingController();
  final TextEditingController _ampThirdWireController = TextEditingController();

  bool _isSecondWireEnabled = false;
  bool _isThirdWireEnabled = false;
  int _dropdownValue = 0; // Current dropdown button value.
  String _coolingTimeHours = '0'; // Cooling time: hours.
  String _coolingTimeMinutes = '0'; // Cooling time: minutes.
  Settings _settings = Settings(); // General app settings.
  List<int> _voltages = <int>[230, 400]; // Store ISO-approved voltages here.

  _HomeRouteState() {
    _initialTempController.text = _initialValue.toString();
    _setTempController.text = _initialValue.toString();
    _volumeController.text = _initialValue.toString();
    _ampFirstWireController.text = _initialValue.toString();
    _ampSecondWireController.text = _initialValue.toString();
    _ampThirdWireController.text = _initialValue.toString();

    _dropdownValue = _voltages.first;
  }

  @override
  void initState() {
    super.initState();
    readDefaultLocale();
  }

  @override
  void dispose() {
    _initialTempController.dispose();
    _setTempController.dispose();
    _volumeController.dispose();
    _ampFirstWireController.dispose();
    _ampSecondWireController.dispose();
    _ampThirdWireController.dispose();
    super.dispose();
  }

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
      _settings.locale.ampFirstWire = locale['ampFirst'];
      _settings.locale.ampSecondWire = locale['ampSecond'];
      _settings.locale.ampThirdWire = locale['ampThird'];
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
  }

  Future<void> readLocale(String name) async {
    String response = '';

    try {
      response = await rootBundle.loadString('assets/locales/$name');
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
      _settings.locale.ampFirstWire = locale['ampFirst'];
      _settings.locale.ampSecondWire = locale['ampSecond'];
      _settings.locale.ampThirdWire = locale['ampThird'];
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
  }

  //
  // Purge all fields from data.
  //
  Calculator purge(Calculator calculator) {
    _calculator.initialTemp = 0.0;
    _calculator.setTemp = 0.0;
    _calculator.volume = 0.0;
    _calculator.ampFirstWire = 0.0;
    _calculator.ampSecondWire = 0.0;
    _calculator.ampThirdWire = 0.0;

    _initialTempController.text = _initialValue.toString();
    _setTempController.text = _initialValue.toString();
    _volumeController.text = _initialValue.toString();
    _ampFirstWireController.text = _initialValue.toString();
    _ampSecondWireController.text = _initialValue.toString();
    _ampThirdWireController.text = _initialValue.toString();

    return calculator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
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
              switch (value) {
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

                      if (!_settings.isOldStandardEnabled) {
                        _voltages = <int>[230, 400];
                      } else {
                        _voltages = <int>[220, 230, 380, 400];
                      }
                    });

                    switch (_settings.currentLocale) {
                      case 'Serbian (Cyrillic)':
                        {
                          readLocale('rs_cyrillic.json');

                          break;
                        }
                      case 'Serbian (Latin)':
                        {
                          readLocale('rs_latin.json');

                          break;
                        }
                      case 'Swedish':
                        {
                          readLocale('sv_se.json');

                          break;
                        }
                      default:
                        {
                          readDefaultLocale();

                          break;
                        }
                    }

                    break;
                  }
                case 3:
                  {
                    SystemNavigator.pop();

                    break;
                  }
              }
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Form(
                child: Center(
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          _settings.locale.hours.isEmpty
                              ? Text('$_coolingTimeHours h. ') // Trailing space is intentional. Do not remove!
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
                        ],
                      ),
                      //
                      // Add an empty space between the form and the text output.
                      //
                      const Padding(
                        padding: EdgeInsets.all(16),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            _coolingTimeHours = '0';
                            _coolingTimeMinutes = '0';
                          });

                          purge(_calculator);
                        },
                        label: _settings.locale.clearAll.isEmpty
                            ? const Text('Clear All')
                            : Text(_settings.locale.clearAll),
                      ),
                      //
                      // Add an empty space between the form and the text output.
                      //
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
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: _settings.locale.voltage.isEmpty
                                      ? const Text('Voltage')
                                      : Text(_settings.locale.voltage),
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
                                    _isSecondWireEnabled = false;
                                    _isThirdWireEnabled = false;
                                  } else {
                                    _isSecondWireEnabled = true;
                                    _isThirdWireEnabled = true;
                                  }

                                  _calculator.initialTemp = double.parse(_initialTempController.text);
                                  _calculator.setTemp = double.parse(_setTempController.text);
                                  _calculator.volume = double.parse(_volumeController.text);
                                  _calculator.ampFirstWire = double.parse(_ampFirstWireController.text);
                                  _calculator.ampSecondWire = double.parse(_ampSecondWireController.text);
                                  _calculator.ampThirdWire = double.parse(_ampThirdWireController.text);

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours = _calculator.getHours().toString();
                                  _coolingTimeMinutes = _calculator.getMinutes().toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _ampFirstWireController,
                              decoration: InputDecoration(
                                counterStyle: const TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: const Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: _settings.locale.ampFirstWire.isEmpty
                                      ? const Text('Amperage 1')
                                      : Text(_settings.locale.ampFirstWire),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              onChanged: (value) {
                                setState(() {
                                  if (_ampFirstWireController.value.text.isEmpty) {
                                    _ampFirstWireController.text = _initialValue.toString();
                                    _ampFirstWireController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _ampFirstWireController.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.ampFirstWire = _initialValue;
                                  } else {
                                    _calculator.ampFirstWire = double.parse(value);
                                  }

                                  if (_calculator.ampFirstWire > _amperageLimit) {
                                    //
                                    // Set member value to pre-defined amperage limit.
                                    //
                                    _calculator.ampFirstWire = _amperageLimit.toDouble();
                                    //
                                    // Assign a new value to the input field.
                                    //
                                    _ampFirstWireController.text = _calculator.ampFirstWire.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours = _calculator.getHours().toString();
                                  _coolingTimeMinutes = _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _ampFirstWireController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _ampFirstWireController.value.text.length,
                                );
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _ampSecondWireController,
                              decoration: !_isSecondWireEnabled
                                  ? InputDecoration(
                                      counterStyle: const TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(211, 211, 211, 0),
                                      label: Center(
                                        child: _settings.locale.ampSecondWire.isEmpty
                                            ? const Text('Amperage 2')
                                            : Text(_settings.locale.ampSecondWire),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Color.fromRGBO(211, 211, 211, 0),
                                      ),
                                    )
                                  : InputDecoration(
                                      counterStyle: const TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(211, 211, 211, 1),
                                      label: Center(
                                        child: _settings.locale.ampSecondWire.isEmpty
                                            ? const Text('Amperage 2')
                                            : Text(_settings.locale.ampSecondWire),
                                      ),
                                    ),
                              enabled: _isSecondWireEnabled,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              onChanged: (value) {
                                setState(() {
                                  if (_ampSecondWireController.text.isEmpty) {
                                    _ampSecondWireController.text = _initialValue.toString();
                                    _ampSecondWireController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _ampSecondWireController.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.ampSecondWire = _initialValue;
                                  } else {
                                    _calculator.ampSecondWire = double.parse(value);
                                  }

                                  if (_calculator.ampSecondWire > _amperageLimit) {
                                    _calculator.ampSecondWire = _amperageLimit.toDouble();
                                    _ampSecondWireController.text = _calculator.ampSecondWire.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours = _calculator.getHours().toString();
                                  _coolingTimeMinutes = _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _ampSecondWireController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _ampSecondWireController.value.text.length,
                                );
                              },
                              style: !_isSecondWireEnabled
                                  ? const TextStyle(
                                      color: Color.fromRGBO(211, 211, 211, 0),
                                      fontSize: 20,
                                    )
                                  : const TextStyle(
                                      fontSize: 20,
                                    ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _ampThirdWireController,
                              decoration: !_isThirdWireEnabled
                                  ? InputDecoration(
                                      counterStyle: const TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor: Colors.white10,
                                      label: Center(
                                        child: _settings.locale.ampThirdWire.isEmpty
                                            ? const Text('Amperage 3')
                                            : Text(_settings.locale.ampThirdWire),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Color.fromRGBO(211, 211, 211, 0),
                                      ),
                                    )
                                  : InputDecoration(
                                      counterStyle: const TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(211, 211, 211, 1),
                                      label: Center(
                                        child: _settings.locale.ampThirdWire.isEmpty
                                            ? const Text('Amperage 3')
                                            : Text(_settings.locale.ampThirdWire),
                                      ),
                                    ),
                              enabled: _isThirdWireEnabled,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              onChanged: (value) {
                                setState(() {
                                  if (_ampThirdWireController.text.isEmpty) {
                                    _ampThirdWireController.text = _initialValue.toString();
                                    _ampThirdWireController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _ampThirdWireController.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.ampThirdWire = _initialValue;
                                  } else {
                                    _calculator.ampThirdWire = double.parse(value);
                                  }

                                  if (_calculator.ampThirdWire > _amperageLimit) {
                                    _calculator.ampThirdWire = _amperageLimit.toDouble();
                                    _ampThirdWireController.text = _calculator.ampThirdWire.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours = _calculator.getHours().toString();
                                  _coolingTimeMinutes = _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _ampThirdWireController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _ampThirdWireController.value.text.length,
                                );
                              },
                              style: !_isThirdWireEnabled
                                  ? const TextStyle(
                                      color: Color.fromRGBO(211, 211, 211, 0),
                                      fontSize: 20,
                                    )
                                  : const TextStyle(
                                      fontSize: 20,
                                    ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _initialTempController,
                              //
                              // Get rid of the counter; do the same thing for
                              // the other fields as well.
                              //
                              decoration: InputDecoration(
                                counterStyle: const TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: const Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: _settings.locale.initialTemp.isEmpty
                                      ? const Text('Initial Temp')
                                      : Text(_settings.locale.initialTemp),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              onChanged: (value) {
                                setState(() {
                                  if (_initialTempController.text.isEmpty) {
                                    _initialTempController.text = _initialValue.toString();
                                    _initialTempController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _initialTempController.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.initialTemp = _initialValue;
                                  } else {
                                    _calculator.initialTemp = double.parse(value);
                                  }

                                  if (_calculator.initialTemp > _initialTempLimit || _calculator.initialTemp < 0) {
                                    _calculator.initialTemp = _initialTempLimit.toDouble();
                                    _initialTempController.text = _calculator.initialTemp.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours = _calculator.getHours().toString();
                                  _coolingTimeMinutes = _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _initialTempController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _initialTempController.value.text.length,
                                );
                              },
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _setTempController,
                              decoration: InputDecoration(
                                counterStyle: const TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: const Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: _settings.locale.setTemp.isEmpty
                                      ? const Text('Set Temp')
                                      : Text(_settings.locale.setTemp),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              onChanged: (value) {
                                setState(() {
                                  if (_setTempController.text.isEmpty) {
                                    _setTempController.text = _initialValue.toString();
                                    _setTempController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _setTempController.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.setTemp = _initialValue;
                                  } else {
                                    _calculator.setTemp = double.parse(value);
                                  }

                                  if (_calculator.setTemp < _setTempLimit || _calculator.setTemp > _initialTempLimit) {
                                    _calculator.setTemp = _setTempLimit.toDouble();
                                    _setTempController.text = _calculator.setTemp.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours = _calculator.getHours().toString();
                                  _coolingTimeMinutes = _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _setTempController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _setTempController.value.text.length,
                                );
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _volumeController,
                              decoration: InputDecoration(
                                counterStyle: const TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: const Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: _settings.locale.volume.isEmpty
                                      ? const Text('Volume')
                                      : Text(_settings.locale.volume),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              onChanged: (value) {
                                setState(() {
                                  if (_volumeController.text.isEmpty) {
                                    _volumeController.text = _initialValue.toString();
                                    _volumeController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _volumeController.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.volume = _initialValue;
                                  } else {
                                    _calculator.volume = double.parse(value);
                                  }

                                  if (_calculator.volume > _volumeLimit) {
                                    _calculator.volume = _volumeLimit.toDouble();
                                    _volumeController.text = _calculator.volume.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours = _calculator.getHours().toString();
                                  _coolingTimeMinutes = _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _volumeController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _volumeController.value.text.length,
                                );
                              },
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
