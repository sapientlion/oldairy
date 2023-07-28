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
  final TextEditingController _tecInitialTemp = TextEditingController();
  final TextEditingController _tecSetTemp = TextEditingController();
  final TextEditingController _tecVolume = TextEditingController();
  final TextEditingController _tecAmpFirstWire = TextEditingController();
  final TextEditingController _tecAmpSecondWire = TextEditingController();
  final TextEditingController _tecAmpThirdWire = TextEditingController();

  bool _isSecondWireEnabled = false;
  bool _isThirdWireEnabled = false;
  int _dropdownValue = 0;
  String _coolingTimeHours = '0';
  String _coolingTimeMinutes = '0';
  Settings _settings = Settings();
  //
  // Store ISO-approved voltages here.
  //
  List<int> _voltages = <int>[230, 400];

  _HomeRouteState() {
    _tecInitialTemp.text = _initialValue.toString();
    _tecSetTemp.text = _initialValue.toString();
    _tecVolume.text = _initialValue.toString();
    _tecAmpFirstWire.text = _initialValue.toString();
    _tecAmpSecondWire.text = _initialValue.toString();
    _tecAmpThirdWire.text = _initialValue.toString();

    _dropdownValue = _voltages.first;
  }

  @override
  void initState() {
    super.initState();
    readDefaultLocale();
  }

  @override
  void dispose() {
    _tecInitialTemp.dispose();
    _tecSetTemp.dispose();
    _tecVolume.dispose();
    _tecAmpFirstWire.dispose();
    _tecAmpSecondWire.dispose();
    _tecAmpThirdWire.dispose();
    super.dispose();
  }

  Future<void> readDefaultLocale() async {
    final String response =
        await rootBundle.loadString('assets/locales/en_us.json');
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
    final String response = await rootBundle.loadString('assets/locales/$name');
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

    _tecInitialTemp.text = _initialValue.toString();
    _tecSetTemp.text = _initialValue.toString();
    _tecVolume.text = _initialValue.toString();
    _tecAmpFirstWire.text = _initialValue.toString();
    _tecAmpSecondWire.text = _initialValue.toString();
    _tecAmpThirdWire.text = _initialValue.toString();

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
                  //const PopupMenuItem<int>(
                  value: 1,
                  child: Text(_settings.locale.settings),
                  //child: Text("Settings"),
                ),
                PopupMenuItem<int>(
                  //const PopupMenuItem<int>(
                  value: 2,
                  child: Text(_settings.locale.about),
                  //child: Text("About"),
                ),
                PopupMenuItem<int>(
                  //const PopupMenuItem<int>(
                  value: 3,
                  child: Text(_settings.locale.exit),
                  //child: Text("Exit"),
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
                          Text(
                            '$_coolingTimeHours ${_settings.locale.hours}',
                            //' $_coolingTimeHours h.',
                            textScaleFactor: 4,
                          ),
                          Text(
                            '$_coolingTimeMinutes ${_settings.locale.minutes}',
                            //' $_coolingTimeMinutes m.',
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
                        label: Text(_settings.locale.clearAll),
                        //label: const Text('Clear All'),
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
                                //decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: Text(_settings.locale.voltage),
                                  //child: Text('Voltage'),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              value: _dropdownValue,
                              items: _voltages
                                  .map<DropdownMenuItem<int>>((int value) {
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

                                  if (_calculator.voltage >= 220 &&
                                      _calculator.voltage <= 230) {
                                    _isSecondWireEnabled = false;
                                    _isThirdWireEnabled = false;
                                  } else {
                                    _isSecondWireEnabled = true;
                                    _isThirdWireEnabled = true;
                                  }

                                  _calculator.initialTemp =
                                      double.parse(_tecInitialTemp.text);
                                  _calculator.setTemp =
                                      double.parse(_tecSetTemp.text);
                                  _calculator.volume =
                                      double.parse(_tecVolume.text);
                                  _calculator.ampFirstWire =
                                      double.parse(_tecAmpFirstWire.text);
                                  _calculator.ampSecondWire =
                                      double.parse(_tecAmpSecondWire.text);
                                  _calculator.ampThirdWire =
                                      double.parse(_tecAmpThirdWire.text);

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours =
                                      _calculator.getHours().toString();
                                  _coolingTimeMinutes =
                                      _calculator.getMinutes().toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _tecAmpFirstWire,
                              decoration: InputDecoration(
                                //decoration: const InputDecoration(
                                counterStyle:
                                    TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: Text(_settings.locale.ampFirstWire),
                                  //child: Text('Amperage 1'),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              onChanged: (value) {
                                setState(() {
                                  if (_tecAmpFirstWire.value.text.isEmpty) {
                                    _tecAmpFirstWire.text =
                                        _initialValue.toString();
                                    _tecAmpFirstWire.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _tecAmpFirstWire.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.ampFirstWire = _initialValue;
                                  } else {
                                    _calculator.ampFirstWire =
                                        double.parse(value);
                                  }

                                  if (_calculator.ampFirstWire >
                                      _amperageLimit) {
                                    //
                                    // Set member value to pre-defined amperage limit.
                                    //
                                    _calculator.ampFirstWire =
                                        _amperageLimit.toDouble();
                                    //
                                    // Assign a new value to the input field.
                                    //
                                    _tecAmpFirstWire.text =
                                        _calculator.ampFirstWire.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours =
                                      _calculator.getHours().toString();
                                  _coolingTimeMinutes =
                                      _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _tecAmpFirstWire.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _tecAmpFirstWire.value.text.length,
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
                              controller: _tecAmpSecondWire,
                              decoration: !_isSecondWireEnabled
                                  ? InputDecoration(
                                      //? const InputDecoration(
                                      counterStyle:
                                          TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(211, 211, 211, 0),
                                      label: Center(
                                        child: Text(
                                            _settings.locale.ampSecondWire),
                                        //child: Text('Amperage 2'),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Color.fromRGBO(211, 211, 211, 0),
                                      ),
                                    )
                                  : InputDecoration(
                                      //: const InputDecoration(
                                      counterStyle:
                                          TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(211, 211, 211, 1),
                                      label: Center(
                                        child: Text(
                                            _settings.locale.ampSecondWire),
                                        //child: Text('Amperage 2'),
                                      ),
                                    ),
                              enabled: _isSecondWireEnabled,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              onChanged: (value) {
                                setState(() {
                                  if (_tecAmpSecondWire.text.isEmpty) {
                                    _tecAmpSecondWire.text =
                                        _initialValue.toString();
                                    _tecAmpSecondWire.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _tecAmpSecondWire.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.ampSecondWire = _initialValue;
                                  } else {
                                    _calculator.ampSecondWire =
                                        double.parse(value);
                                  }

                                  if (_calculator.ampSecondWire >
                                      _amperageLimit) {
                                    _calculator.ampSecondWire =
                                        _amperageLimit.toDouble();
                                    _tecAmpSecondWire.text =
                                        _calculator.ampSecondWire.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours =
                                      _calculator.getHours().toString();
                                  _coolingTimeMinutes =
                                      _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _tecAmpSecondWire.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _tecAmpSecondWire.value.text.length,
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
                              controller: _tecAmpThirdWire,
                              decoration: !_isThirdWireEnabled
                                  ? InputDecoration(
                                      //? const InputDecoration(
                                      counterStyle:
                                          TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor: Colors.white10,
                                      label: Center(
                                        child:
                                            Text(_settings.locale.ampThirdWire),
                                        //child: Text('Amperage 3'),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Color.fromRGBO(211, 211, 211, 0),
                                      ),
                                    )
                                  : InputDecoration(
                                      //: const InputDecoration(
                                      counterStyle:
                                          TextStyle(height: double.minPositive),
                                      counterText: '',
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(211, 211, 211, 1),
                                      label: Center(
                                        child:
                                            Text(_settings.locale.ampThirdWire),
                                        //child: Text('Amperage 3'),
                                      ),
                                    ),
                              enabled: _isThirdWireEnabled,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              onChanged: (value) {
                                setState(() {
                                  if (_tecAmpThirdWire.text.isEmpty) {
                                    _tecAmpThirdWire.text =
                                        _initialValue.toString();
                                    _tecAmpThirdWire.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _tecAmpThirdWire.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.ampThirdWire = _initialValue;
                                  } else {
                                    _calculator.ampThirdWire =
                                        double.parse(value);
                                  }

                                  if (_calculator.ampThirdWire >
                                      _amperageLimit) {
                                    _calculator.ampThirdWire =
                                        _amperageLimit.toDouble();
                                    _tecAmpThirdWire.text =
                                        _calculator.ampThirdWire.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours =
                                      _calculator.getHours().toString();
                                  _coolingTimeMinutes =
                                      _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _tecAmpThirdWire.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _tecAmpThirdWire.value.text.length,
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
                              controller: _tecInitialTemp,
                              //
                              // Get rid of the counter; do the same thing for
                              // the other fields as well.
                              //
                              decoration: InputDecoration(
                                //decoration: const InputDecoration(
                                counterStyle:
                                    TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: Text(_settings.locale.initialTemp),
                                  //child: Text('Initial Temp'),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              onChanged: (value) {
                                setState(() {
                                  if (_tecInitialTemp.text.isEmpty) {
                                    _tecInitialTemp.text =
                                        _initialValue.toString();
                                    _tecInitialTemp.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _tecInitialTemp.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.initialTemp = _initialValue;
                                  } else {
                                    _calculator.initialTemp =
                                        double.parse(value);
                                  }

                                  if (_calculator.initialTemp >
                                          _initialTempLimit ||
                                      _calculator.initialTemp < 0) {
                                    _calculator.initialTemp =
                                        _initialTempLimit.toDouble();
                                    _tecInitialTemp.text =
                                        _calculator.initialTemp.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours =
                                      _calculator.getHours().toString();
                                  _coolingTimeMinutes =
                                      _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _tecInitialTemp.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _tecInitialTemp.value.text.length,
                                );
                              },
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 128,
                            child: TextFormField(
                              autocorrect: false,
                              controller: _tecSetTemp,
                              decoration: InputDecoration(
                                //decoration: const InputDecoration(
                                counterStyle:
                                    TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: Text(_settings.locale.setTemp),
                                  //child: Text('Set Temp'),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              onChanged: (value) {
                                setState(() {
                                  if (_tecSetTemp.text.isEmpty) {
                                    _tecSetTemp.text = _initialValue.toString();
                                    _tecSetTemp.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _tecSetTemp.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.setTemp = _initialValue;
                                  } else {
                                    _calculator.setTemp = double.parse(value);
                                  }

                                  if (_calculator.setTemp < _setTempLimit ||
                                      _calculator.setTemp > _initialTempLimit) {
                                    _calculator.setTemp =
                                        _setTempLimit.toDouble();
                                    _tecSetTemp.text =
                                        _calculator.setTemp.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours =
                                      _calculator.getHours().toString();
                                  _coolingTimeMinutes =
                                      _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _tecSetTemp.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _tecSetTemp.value.text.length,
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
                              controller: _tecVolume,
                              decoration: InputDecoration(
                                //decoration: const InputDecoration(
                                counterStyle:
                                    TextStyle(height: double.minPositive),
                                counterText: '',
                                filled: true,
                                fillColor: Color.fromRGBO(211, 211, 211, 1),
                                label: Center(
                                  child: Text(_settings.locale.volume),
                                  //child: Text('Volume'),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              onChanged: (value) {
                                setState(() {
                                  if (_tecVolume.text.isEmpty) {
                                    _tecVolume.text = _initialValue.toString();
                                    _tecVolume.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _tecVolume.value.text.length,
                                    );
                                  }

                                  if (double.tryParse(value) == null) {
                                    _calculator.volume = _initialValue;
                                  } else {
                                    _calculator.volume = double.parse(value);
                                  }

                                  if (_calculator.volume > _volumeLimit) {
                                    _calculator.volume =
                                        _volumeLimit.toDouble();
                                    _tecVolume.text =
                                        _calculator.volume.toString();
                                  }

                                  _calculator.calculate(_dropdownValue);
                                  _coolingTimeHours =
                                      _calculator.getHours().toString();
                                  _coolingTimeMinutes =
                                      _calculator.getMinutes().toString();
                                });
                              },
                              onTap: () {
                                _tecVolume.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _tecVolume.value.text.length,
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
