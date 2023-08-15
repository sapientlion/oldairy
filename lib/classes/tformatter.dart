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

	Description: N/a

*/

class TimeFormatter {
  int cTimeHours = 0;
  int cTimeMinutes = 0;
  double cTime = 0.0;

  TimeFormatter({
    this.cTimeHours = 0,
    this.cTimeMinutes = 0,
    this.cTime = 0.0,
  });

  //
  // Round time.
  //
  double round() {
    const int numOfMinutesInOneHour = 60;
    bool fpFlag = false; // Floating point flag.
    /*int cTimeMinutes = 0;
    int cTimeHours = 0;*/
    double cTime = 0.0;
    String cTimeAsString = cTime.toString();
    String cTimeMinutesAsString = '';

    //
    // Extract minutes from the total cooling time. Use the following approach for better reliability when using
    // different encodings.
    //
    for (var element in cTimeAsString.runes) {
      //
      // Detect the first occurence of the floating point.
      //
      if (!fpFlag && String.fromCharCode(element) == '.') {
        fpFlag = true;
      }

      //
      // Start including digits until after the floating point is reached.
      //
      if (fpFlag) {
        cTimeMinutesAsString += String.fromCharCode(element);
      }
    }

    cTimeMinutes = int.parse(cTimeMinutesAsString);

    if (cTimeMinutes < numOfMinutesInOneHour) {
      return cTime;
    }

    //
    // Round the cooling time.
    //
    while (cTimeMinutes > numOfMinutesInOneHour) {
      cTimeHours++;
      //
      // TODO the following may result in imprecise value. Check this out later.
      //
      cTimeMinutes = cTimeMinutes ~/ numOfMinutesInOneHour;
    }

    cTime = cTimeMinutes.toDouble();
    cTimeMinutesAsString = cTimeMinutes.toString();

    //
    // Add digits after the floating point.
    //
    for (int index = 0; index < cTimeMinutesAsString.length; index++) {
      cTime /= 10;
    }

    return cTime += cTimeHours;
  }

  double get() {
    round();

    return cTime;
  }

  int getHours() {
    round();

    return cTimeHours;
  }

  int getMinutes() {
    round();

    return cTimeMinutes;
  }
}
