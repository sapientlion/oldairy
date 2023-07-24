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

  int _dropdownValue = 0;
  TextFormField _tffAmpFirstWireField = TextFormField();
  TextFormField _tffAmpSecondWireField = TextFormField();
  TextFormField _tffAmpThirdWireField = TextFormField();

  _HomePageState() {
    _tecInitialTemp.text = _initialValue.toString();
    _tecSetTemp.text = _initialValue.toString();
    _tecVolume.text = _initialValue.toString();
    _tecAmpFirstWire.text = _initialValue.toString();
    _tecAmpSecondWire.text = _initialValue.toString();
    _tecAmpThirdWire.text = _initialValue.toString();

    _tffAmpFirstWireField = TextFormField(
      autocorrect: false,
      controller: _tecAmpFirstWire,
      decoration: const InputDecoration(
        counterStyle: TextStyle(height: double.minPositive),
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
            _tecAmpFirstWire.text = _initialValue.toString();
            _tecAmpFirstWire.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _tecAmpFirstWire.value.text.length,
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
            _tecAmpFirstWire.text = _calculator.ampFirstWire.toString();
          }

          _calculator.calculate(_dropdownValue);
        });
      },
      onTap: () {
        _tecAmpFirstWire.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _tecAmpFirstWire.value.text.length,
        );
      },
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );

    _dropdownValue = _voltages.first;

    switchPhaseFields(_voltages.first);
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
  // Three-phase electric power: switch state of the second wire field.
  //
  void switchSecondWireField(int voltage) {
    if (voltage == 220 || voltage == 230) {
      _tffAmpSecondWireField = TextFormField(
        autocorrect: false,
        controller: _tecAmpSecondWire,
        decoration: const InputDecoration(
          counterStyle: TextStyle(height: double.minPositive),
          counterText: '',
          filled: true,
          fillColor: Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child: Text('Amperage'),
          ),
        ),
        enabled: false,
        keyboardType: TextInputType.number,
        maxLength: 8,
        onChanged: (value) {
          setState(() {
            if (_tecAmpSecondWire.text.isEmpty) {
              _tecAmpSecondWire.text = _initialValue.toString();
              _tecAmpSecondWire.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _tecAmpSecondWire.value.text.length,
              );
            }

            if (double.tryParse(value) == null) {
              _calculator.ampSecondWire = _initialValue;
            } else {
              _calculator.ampSecondWire = double.parse(value);
            }

            if (_calculator.ampSecondWire > _amperageLimit) {
              _calculator.ampSecondWire = _amperageLimit.toDouble();
              _tecAmpSecondWire.text = _calculator.ampSecondWire.toString();
            }

            _calculator.calculate(_dropdownValue);
          });
        },
        onTap: () {
          _tecAmpSecondWire.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _tecAmpSecondWire.value.text.length,
          );
        },
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );

      return;
    }

    //
    // Execute the following when using 380/440 volts.
    //
    _tffAmpSecondWireField = TextFormField(
      autocorrect: false,
      controller: _tecAmpSecondWire,
      decoration: const InputDecoration(
        counterStyle: TextStyle(height: double.minPositive),
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
          if (_tecAmpSecondWire.text.isEmpty) {
            _tecAmpSecondWire.text = _initialValue.toString();
            _tecAmpSecondWire.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _tecAmpSecondWire.value.text.length,
            );
          }

          if (double.tryParse(value) == null) {
            _calculator.ampSecondWire = _initialValue;
          } else {
            _calculator.ampSecondWire = double.parse(value);
          }

          if (_calculator.ampSecondWire > _amperageLimit) {
            _calculator.ampSecondWire = _amperageLimit.toDouble();
            _tecAmpSecondWire.text = _calculator.ampSecondWire.toString();
          }

          _calculator.calculate(_dropdownValue);
        });
      },
      onTap: () {
        _tecAmpSecondWire.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _tecAmpSecondWire.value.text.length,
        );
      },
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );

    return;
  }

  //
  // Three-phase electric power: switch state of the thrid wire field.
  //
  void switchThirdWireField(int voltage) {
    if (voltage == 220 || voltage == 230) {
      _tffAmpThirdWireField = TextFormField(
        autocorrect: false,
        controller: _tecAmpThirdWire,
        decoration: const InputDecoration(
          counterStyle: TextStyle(height: double.minPositive),
          counterText: '',
          filled: true,
          fillColor: Color.fromRGBO(211, 211, 211, 1),
          label: Center(
            child: Text('Amperage'),
          ),
        ),
        enabled: false,
        keyboardType: TextInputType.number,
        maxLength: 8,
        onChanged: (value) {
          setState(() {
            if (_tecAmpThirdWire.text.isEmpty) {
              _tecAmpThirdWire.text = _initialValue.toString();
              _tecAmpThirdWire.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _tecAmpThirdWire.value.text.length,
              );
            }

            if (double.tryParse(value) == null) {
              _calculator.ampThirdWire = _initialValue;
            } else {
              _calculator.ampThirdWire = double.parse(value);
            }

            if (_calculator.ampThirdWire > _amperageLimit) {
              _calculator.ampThirdWire = _amperageLimit.toDouble();
              _tecAmpThirdWire.text = _calculator.ampThirdWire.toString();
            }

            _calculator.calculate(_dropdownValue);
          });
        },
        onTap: () {
          _tecAmpThirdWire.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _tecAmpThirdWire.value.text.length,
          );
        },
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );

      return;
    }

    //
    // Execute the following when using 380/400 volts.
    //
    _tffAmpThirdWireField = TextFormField(
      autocorrect: false,
      controller: _tecAmpThirdWire,
      decoration: const InputDecoration(
        counterStyle: TextStyle(height: double.minPositive),
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
          if (_tecAmpThirdWire.text.isEmpty) {
            _tecAmpThirdWire.text = _initialValue.toString();
            _tecAmpThirdWire.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _tecAmpThirdWire.value.text.length,
            );
          }

          if (double.tryParse(value) == null) {
            _calculator.ampThirdWire = _initialValue;
          } else {
            _calculator.ampThirdWire = double.parse(value);
          }

          if (_calculator.ampThirdWire > _amperageLimit) {
            _calculator.ampThirdWire = _amperageLimit.toDouble();
            _tecAmpThirdWire.text = _calculator.ampThirdWire.toString();
          }

          _calculator.calculate(_dropdownValue);
        });
      },
      onTap: () {
        _tecAmpThirdWire.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _tecAmpThirdWire.value.text.length,
        );
      },
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );

    return;
  }

  //
  // Three-phase electric power: switch the state of wire fields all at once.
  //
  void switchPhaseFields(int voltage) {
    if (voltage == 220 || voltage == 230) {
      switchSecondWireField(voltage);
      switchThirdWireField(voltage);

      return;
    }

    switchSecondWireField(voltage);
    switchThirdWireField(voltage);

    return;
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
                      '${_calculator.getCoolingTime()}',
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

                                switchPhaseFields(_calculator.voltage.toInt());
                                _calculator.calculate(_dropdownValue);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: _tffAmpFirstWireField,
                        ),
                        SizedBox(
                          width: 128,
                          child: _tffAmpSecondWireField,
                        ),
                        SizedBox(
                          width: 128,
                          child: _tffAmpThirdWireField,
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
