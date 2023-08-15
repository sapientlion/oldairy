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

class TimeFormatter {
  int _cTimeHours = 0;
  int _cTimeMinutes = 0;

  /*int cTimeHours = 0;
  int cTimeMinutes = 0;*/
  double cTime = 0.0;

  TimeFormatter({
    /*this.cTimeHours = 0,
    this.cTimeMinutes = 0,*/
    this.cTime = 0.0,
  });

  int extractMinutes() {
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
  }

  //
  // Round time.
  //
  double round() {
    //
    // Why waste CPU cycles when you can do something more productive than this.
    //
    if (cTime <= 0) {
      return cTime;
    }

    const int numOfMinutesInOneHour = 60; // Well, obviously.
    //bool fpFlag = false; // Floating point flag.
    double cTimeRounded = 0.0;
    //String cTimeAsString = cTime.toString();
    String cTimeMinutesAsString = '';

    _cTimeMinutes = extractMinutes();

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
      return cTime;
    }

    //
    // Round given time.
    //
    while (_cTimeMinutes > numOfMinutesInOneHour) {
      _cTimeHours++;
      //
      // TODO the following may result in imprecise value. Check this out later.
      //
      _cTimeMinutes = _cTimeMinutes ~/ numOfMinutesInOneHour;
    }

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
    cTime = cTime.toInt().toDouble();

    return cTime += _cTimeHours.toDouble() + cTimeRounded;
  }

  double get(bool rFlag) {
    if (cTime <= 0) {
      return cTime;
    }

    if (!rFlag) {
      return cTime;
    }

    return cTime = round();
  }

  int getHours(bool rFlag) {
    if (cTime <= 0) {
      return cTime.toInt();
    }

    if (!rFlag) {
      return cTime.toInt();
    }

    round();

    return cTime.toInt();
  }

  int getMinutes(bool rFlag) {
    if (cTime <= 0) {
      return extractMinutes();
    }

    if (!rFlag) {
      return extractMinutes();
    }

    round();

    return _cTimeMinutes;
  }
}
