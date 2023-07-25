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
  // Calculate using the lower voltages (220V to 230V as defined by ISO).
  //
  double calculateLow(int voltage) {
    if (voltage < 220 || voltage > 230) {
      return _coolingTime = 0.0;
    }

    _coolingTime /= ampFirstWire;

    String coolingTimeRound = _coolingTime.toStringAsFixed(2);

    _coolingTime = double.parse(coolingTimeRound);

    return _coolingTime;
  }

  //
  // Calculate using the higher voltages (380V to 400V as defined by ISO).
  //
  double calculateHigh(int voltage) {
    if (voltage < 380 || voltage > 400) {
      return _coolingTime = 0.0;
    }

    if (ampSecondWire > _amperageLimit) {
      return _coolingTime = 0.0;
    }

    if (ampThirdWire > _amperageLimit) {
      return _coolingTime = 0.0;
    }

    //
    // Switch to three-phase electric power in case of higher voltages.
    //
    double combinedAmperage = ampFirstWire + ampSecondWire + ampThirdWire;

    combinedAmperage = combinedAmperage / sqrt(3);

    if (combinedAmperage <= 0) {
      return _coolingTime = 0.0;
    }

    _coolingTime = _coolingTime / combinedAmperage;

    String coolingTimeRound = _coolingTime.toStringAsFixed(2);

    _coolingTime = double.parse(coolingTimeRound);

    return _coolingTime;
  }

  //
  // Find out total amount of time necessary to cool down an industrial-sized
  // milk tank.
  //
  double calculate(int voltage) {
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
    if (ampFirstWire <= 0 || ampFirstWire > _amperageLimit) {
      return _coolingTime = 0.0;
    }

    if (voltage >= 220 && voltage <= 230) {
      return calculateLow(voltage);
    }

    if (voltage >= 380 && voltage <= 400) {
      return calculateHigh(voltage);
    }

    return _coolingTime = 0.0;
  }
}
