import 'package:flutter/material.dart';

import 'package:oldairy/classes/calculator.dart';

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
      home: HomePage(
        title: _appTitle,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _amperageLimit = 125;
  final double _initialValue = 0.0;
  final Calculator _calculator = Calculator();
  final List<int> _voltages = <int>[
    220,
    230,
    380,
    400
  ]; // Use ISO-approved voltages.
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

  _HomePageState() {
    _tecInitialTemp.text = _initialValue.toString();
    _tecSetTemp.text = _initialValue.toString();
    _tecVolume.text = _initialValue.toString();
    _tecAmpFirstWire.text = _initialValue.toString();
    _tecAmpSecondWire.text = _initialValue.toString();
    _tecAmpThirdWire.text = _initialValue.toString();

    _dropdownValue = _voltages.first;
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Form(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      '$_coolingTimeHours h.',
                      textScaleFactor: 4,
                    ),
                    Text(
                      '$_coolingTimeMinutes m.',
                      textScaleFactor: 4,
                    ),
                    //
                    // Add an empty space between the form and the text output.
                    //
                    const Padding(
                      padding: EdgeInsets.all(24),
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        purge(_calculator);
                      },
                      label: const Text('Clear All'),
                    ),
                    //
                    // Add an empty space between the form and the text output.
                    //
                    const Padding(
                      padding: EdgeInsets.all(24),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 32,
                      spacing: 32,
                      children: [
                        SizedBox(
                          width: 128,
                          child: TextFormField(
                            autocorrect: false,
                            controller: _tecInitialTemp,
                            //
                            // Get rid of the counter; do the same thing for
                            // the other fields as well.
                            //
                            decoration: const InputDecoration(
                              counterStyle:
                                  TextStyle(height: double.minPositive),
                              counterText: '',
                              filled: true,
                              fillColor: Color.fromRGBO(211, 211, 211, 1),
                              label: Center(
                                child: Text('Initial Temp'),
                              ),
                            ),
                            style: const TextStyle(fontSize: 20),
                            keyboardType: TextInputType.number,
                            maxLength: 12,
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
                                  _calculator.initialTemp = double.parse(value);
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
                                extentOffset: _tecInitialTemp.value.text.length,
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
                            decoration: const InputDecoration(
                              counterStyle:
                                  TextStyle(height: double.minPositive),
                              counterText: '',
                              filled: true,
                              fillColor: Color.fromRGBO(211, 211, 211, 1),
                              label: Center(
                                child: Text('Set Temp'),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            onChanged: (value) {
                              setState(() {
                                if (_tecSetTemp.text.isEmpty) {
                                  _tecSetTemp.text = _initialValue.toString();
                                  _tecSetTemp.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: _tecSetTemp.value.text.length,
                                  );
                                }

                                if (double.tryParse(value) == null) {
                                  _calculator.setTemp = _initialValue;
                                } else {
                                  _calculator.setTemp = double.parse(value);
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
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: TextFormField(
                            autocorrect: false,
                            controller: _tecVolume,
                            decoration: const InputDecoration(
                              counterStyle:
                                  TextStyle(height: double.minPositive),
                              counterText: '',
                              filled: true,
                              fillColor: Color.fromRGBO(211, 211, 211, 1),
                              label: Center(
                                child: Text('Volume'),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            onChanged: (value) {
                              setState(() {
                                if (_tecVolume.text.isEmpty) {
                                  _tecVolume.text = _initialValue.toString();
                                  _tecVolume.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: _tecVolume.value.text.length,
                                  );
                                }

                                if (double.tryParse(value) == null) {
                                  _calculator.volume = _initialValue;
                                } else {
                                  _calculator.volume = double.parse(value);
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
                        SizedBox(
                          width: 128,
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(211, 211, 211, 1),
                              label: Center(
                                child: Text('Voltage'),
                              ),
                              labelStyle: TextStyle(fontSize: 20),
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
                            decoration: const InputDecoration(
                              counterStyle:
                                  TextStyle(height: double.minPositive),
                              counterText: '',
                              filled: true,
                              fillColor: Color.fromRGBO(211, 211, 211, 1),
                              label: Center(
                                child: Text('Amperage'),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
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

                                if (_calculator.ampFirstWire > _amperageLimit) {
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
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: TextFormField(
                            autocorrect: false,
                            controller: _tecAmpSecondWire,
                            decoration: const InputDecoration(
                              counterStyle:
                                  TextStyle(height: double.minPositive),
                              counterText: '',
                              filled: true,
                              fillColor: Color.fromRGBO(211, 211, 211, 1),
                              label: Center(
                                child: Text('Amperage'),
                              ),
                            ),
                            enabled: _isSecondWireEnabled,
                            keyboardType: TextInputType.number,
                            maxLength: 8,
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
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: TextFormField(
                            autocorrect: false,
                            controller: _tecAmpThirdWire,
                            decoration: const InputDecoration(
                              counterStyle:
                                  TextStyle(height: double.minPositive),
                              counterText: '',
                              filled: true,
                              fillColor: Color.fromRGBO(211, 211, 211, 1),
                              label: Center(
                                child: Text('Amperage'),
                              ),
                            ),
                            enabled: _isThirdWireEnabled,
                            keyboardType: TextInputType.number,
                            maxLength: 8,
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

                                if (_calculator.ampThirdWire > _amperageLimit) {
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
    );
  }
}
