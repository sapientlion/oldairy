import 'package:flutter/material.dart';

import 'package:oldairy/classes/calculator.dart';

class Oldairy extends StatelessWidget {
  const Oldairy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocadia',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(title: 'Pocadia'),
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
  int _dropdownValue = 0;
  final double _initialValue = 0.0;
  final Calculator _calculator = Calculator();
  final List<int> _voltages = <int>[
    220,
    230,
    380,
    400
  ]; // Use ISO-approved voltages.

  TextFormField _tecAmpFirstWireField = TextFormField();
  TextFormField _tecAmpSecondWireField = TextFormField();
  TextFormField _tecAmpThirdWireField = TextFormField();

  _HomePageState() {
    _tecAmpFirstWireField = TextFormField(
      autocorrect: false,
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
          if (double.tryParse(value) == null) {
            _calculator.ampFirstWire = _initialValue;
          } else {
            _calculator.ampFirstWire = double.parse(value);
          }

          _calculator.calculate();
        });
      },
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );

    _dropdownValue = _voltages.first;

    switchPhaseFields(_voltages.first);
  }

  //
  // Three-phase electric power: switch state of the second wire field.
  //
  void switchSecondWireField(int voltage) {
    if (voltage == 220 || voltage == 230) {
      _tecAmpSecondWireField = TextFormField(
        autocorrect: false,
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
            if (double.tryParse(value) == null) {
              _calculator.ampFirstWire = _initialValue;
            } else {
              _calculator.ampFirstWire = double.parse(value);
            }

            _calculator.calculate();
          });
        },
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );

      return;
    }

    //
    // Execute the following when using 380/440 volts.
    //
    _tecAmpSecondWireField = TextFormField(
      autocorrect: false,
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
          if (double.tryParse(value) == null) {
            _calculator.ampFirstWire = _initialValue;
          } else {
            _calculator.ampFirstWire = double.parse(value);
          }

          _calculator.calculate();
        });
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
      _tecAmpThirdWireField = TextFormField(
        autocorrect: false,
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
            if (double.tryParse(value) == null) {
              _calculator.ampFirstWire = _initialValue;
            } else {
              _calculator.ampFirstWire = double.parse(value);
            }

            _calculator.calculate();
          });
        },
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );

      return;
    }

    //
    // Execute the following when using 380/400 volts.
    //
    _tecAmpThirdWireField = TextFormField(
      autocorrect: false,
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
          if (double.tryParse(value) == null) {
            _calculator.ampFirstWire = _initialValue;
          } else {
            _calculator.ampFirstWire = double.parse(value);
          }

          _calculator.calculate();
        });
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
                      padding: EdgeInsets.all(32),
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
                                if (double.tryParse(value) == null) {
                                  _calculator.initialTemp = _initialValue;
                                } else {
                                  _calculator.initialTemp = double.parse(value);
                                }

                                _calculator.calculate();
                              });
                            },
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: TextFormField(
                            autocorrect: false,
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
                                if (double.tryParse(value) == null) {
                                  _calculator.setTemp = _initialValue;
                                } else {
                                  _calculator.setTemp = double.parse(value);
                                }

                                _calculator.calculate();
                              });
                            },
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: TextFormField(
                            autocorrect: false,
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
                                if (double.tryParse(value) == null) {
                                  _calculator.volume = _initialValue;
                                } else {
                                  _calculator.volume = double.parse(value);
                                }

                                _calculator.calculate();
                              });
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
                                _calculator.calculate();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 128,
                          child: _tecAmpFirstWireField,
                        ),
                        SizedBox(
                          width: 128,
                          child: _tecAmpSecondWireField,
                        ),
                        SizedBox(
                          width: 128,
                          child: _tecAmpThirdWireField,
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
