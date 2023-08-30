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

	Description: time formatter class.

*/

import 'calculator.dart';

class TimeFormatter {
  int _cTimeHours = 0;
  int _cTimeMinutes = 0;

  /*int cTimeHours = 0;
  int cTimeMinutes = 0;*/
  double _cTime = 0.0;
  //double cTime = 0.0;

  Calculator calculator = Calculator(
    initialTemp: 0.0,
    setTemp: 0.0,
    volume: 0.0,
    voltage: 0.0,
    ampsFirstWire: 0.0,
    ampsSecondWire: 0.0,
    ampsThirdWire: 0.0,
  );

  TimeFormatter({
    required this.calculator,
  }) {
    calculator.calculate();

    _cTime = calculator.get();
  }

  /*TimeFormatter({
    this.cTimeHours = 0,
    this.cTimeMinutes = 0,
    this.cTime = 0.0,
  });*/

  //
  // Get fraction of the given number.
  //
  int getFraction(String value) {
    if (value.isEmpty) {
      return 0;
    }

    bool dpFlag = false; // Decimla point flag.
    String resValue = '';

    for (var element in value.runes) {
      //
      // Start including digits until after the floating point is reached.
      //
      if (dpFlag) {
        resValue += String.fromCharCode(element);
      }

      //
      // Detect the first occurence of the floating point.
      //
      if (!dpFlag && String.fromCharCode(element) == '.') {
        dpFlag = true;
      }
    }

    return int.parse(resValue);
  }

  //
  // TODO remove this once confirmed that it is no longer needed by the class.
  //
  /*int extractMinutes({bool mpmFlag = true}) {
    if (cTime <= 0) {
      return _cTimeMinutes;
    }

    return _cTimeMinutes = getFraction(cTime.toString());
  }*/

  /*int extractMinutes() {
    if (cTime <= 0) {
      return _cTimeMinutes;
    }

    bool fpFlag = false; // Floating point flag.
    String cTimeAsString = cTime.toString();
    String cTimeMinutesAsString = '';

    //
    // Extract minutes from the given time. Use the following approach for better reliability when using
    // different encodings.
    //
    for (var element in cTimeAsString.runes) {
      //
      // Start including digits until after the floating point is reached.
      //
      if (fpFlag) {
        cTimeMinutesAsString += String.fromCharCode(element);
      }

      //
      // Detect the first occurence of the floating point.
      //
      if (!fpFlag && String.fromCharCode(element) == '.') {
        fpFlag = true;
      }
    }

    return _cTimeMinutes = int.parse(cTimeMinutesAsString);
  }*/

  //
  // Round time.
  //
  double round({bool mpmFlag = true}) {
    //
    // Why waste CPU cycles when you can do something more productive than this.
    //
    if (_cTime <= 0) {
      return _cTime;
    }

    const int numOfMinutesInOneHour = 60; // Well, obviously.
    //bool fpFlag = false; // Floating point flag.
    double cTimeRounded = 0.0;
    //String cTimeAsString = cTime.toString();
    String cTimeMinutesAsString = '';

    _cTimeHours = 0;
    _cTimeMinutes = getFraction(_cTime.toString());
    //_cTimeMinutes = extractMinutes();

    //
    // Extract minutes from the given time. Use the following approach for better reliability when using
    // different encodings.
    //
    /*for (var element in cTimeAsString.runes) {
      //
      // Start including digits until after the floating point is reached.
      //
      if (fpFlag) {
        cTimeMinutesAsString += String.fromCharCode(element);
      }

      //
      // Detect the first occurence of the floating point.
      //
      if (!fpFlag && String.fromCharCode(element) == '.') {
        fpFlag = true;
      }
    }

    _cTimeMinutes = int.parse(cTimeMinutesAsString);*/

    //
    // Don't bother with rounding if minutes are less than or equal to 60 minutes.
    //
    if (_cTimeMinutes <= numOfMinutesInOneHour) {
      return _cTime;
    }

    //
    // Round given time.
    //
    if (mpmFlag) {
      while (_cTimeMinutes > numOfMinutesInOneHour) {
        double remainder = 0.0;

        _cTimeHours++;

        remainder = _cTimeMinutes / numOfMinutesInOneHour;
        _cTimeMinutes = remainder.toInt();
        //double remainder = _cTimeMinutes / numOfMinutesInOneHour;

        if (getFraction(remainder.toString()) >= 5) {
          _cTimeMinutes++;
        }
        //_cTimeMinutes = _cTimeMinutes ~/ numOfMinutesInOneHour;
      }
    } else {
      while (_cTimeMinutes > numOfMinutesInOneHour) {
        _cTimeHours++;
        _cTimeMinutes = _cTimeMinutes ~/ numOfMinutesInOneHour;
      }
    }

    /*while (_cTimeMinutes > numOfMinutesInOneHour) {
      double remainder = 0.0;

      _cTimeHours++;

      remainder = _cTimeMinutes / numOfMinutesInOneHour;
      _cTimeMinutes = remainder.toInt();
      //double remainder = _cTimeMinutes / numOfMinutesInOneHour;

      if (getRemainder(remainder.toString()) >= 5) {
        _cTimeMinutes++;
      }
      //_cTimeMinutes = _cTimeMinutes ~/ numOfMinutesInOneHour;
    }*/

    cTimeRounded = _cTimeMinutes.toDouble();
    cTimeMinutesAsString = _cTimeMinutes.toString();

    //
    // Add digits after the floating point.
    //
    for (int index = 0; index < cTimeMinutesAsString.length; index++) {
      cTimeRounded /= 10;
    }

    //
    // Get rid of the digits after the floating point.
    //
    _cTime = _cTime.toInt().toDouble();

    return _cTime += _cTimeHours.toDouble() + cTimeRounded;
  }

  double get(bool rFlag) {
    if (_cTime <= 0) {
      return _cTime;
    }

    if (!rFlag) {
      return _cTime;
    }

    return _cTime = round();
  }

  int getHours(bool rFlag) {
    _cTime = calculator.get();

    if (_cTime <= 0) {
      return _cTime.toInt();
    }

    if (!rFlag) {
      return _cTime.toInt();
    }

    round();

    return _cTime.toInt();
  }

  int getMinutes(bool rFlag, {bool mpmFlag = true}) {
    _cTime = calculator.get();

    if (_cTime <= 0) {
      return _cTimeMinutes;
      //return extractMinutes(mpmFlag: mpmFlag);
    }

    //
    // Do not round time.
    //
    if (!rFlag) {
      return _cTimeMinutes = getFraction(_cTime.toString());
      //return extractMinutes(mpmFlag: mpmFlag);
    }

    //
    // Ignore previous statement.
    //
    round(mpmFlag: mpmFlag);

    return _cTimeMinutes;
  }
}
