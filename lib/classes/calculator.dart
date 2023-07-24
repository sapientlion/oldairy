import 'dart:math';

class Calculator {
  final int _amperageLimit = 125;
  final double _constant = 0.6;

  double _coolingTime = 0.0;

  double initialTemp = 0.0;
  double setTemp = 0.0;
  double volume = 0.0;
  double voltage = 0.0;
  double ampFirstWire = 0.0;
  double ampSecondWire = 0.0;
  double ampThirdWire = 0.0;

  Calculator({
    this.initialTemp = 0.0,
    this.setTemp = 0.0,
    this.volume = 0.0,
    this.voltage = 0.0,
    this.ampFirstWire = 0.0,
    this.ampSecondWire = 0.0,
    this.ampThirdWire = 0.0,
  });

  //
  // Get cooling time.
  //
  double getCoolingTime() {
    return _coolingTime;
  }

  //
  // Find out total amount of time necessary to cool down an industrial-sized
  // milk tank.
  //
  double calculate() {
    _coolingTime = initialTemp - setTemp;

    //
    // No point in going any further when the result will always be the same
    // and equal to 0.
    //
    if (_coolingTime <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime = _constant * _coolingTime;
    _coolingTime = volume * _coolingTime;

    //
    // Division by zero is undefined.
    //
    if (voltage <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime /= voltage;

    //
    // Same thing can happen here.
    //
    if (ampFirstWire > _amperageLimit) {
      return _coolingTime = 0.0;
    }

    if (voltage == 220 || voltage == 230) {
      if (ampFirstWire <= 0) {
        return _coolingTime = 0.0;
      }

      _coolingTime /= ampFirstWire;
    }

    if (ampSecondWire > _amperageLimit) {
      return _coolingTime = 0.0;
    }

    if (ampThirdWire > _amperageLimit) {
      return _coolingTime;
    }

    //
    // Switch to three-phase electric power in case of higher voltages.
    //
    if (voltage == 380 || voltage == 400) {
      ampFirstWire += ampSecondWire + ampThirdWire;
      ampFirstWire = ampFirstWire / sqrt(3);

      if (ampFirstWire <= 0) {
        return _coolingTime = 0.0;
      }

      _coolingTime = _coolingTime / ampFirstWire;
    }

    String coolingTimeRound = _coolingTime.toStringAsFixed(2);

    _coolingTime = double.parse(coolingTimeRound);

    return _coolingTime;
  }
}
