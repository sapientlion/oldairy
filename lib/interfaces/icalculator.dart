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

	Description: calculator interface.

*/

abstract class ICalculator {
  //
  // Get total cooling time as a double literal.
  //
  /*double getCoolingTime();
  //
  // Get total cooling time (hours only).
  //
  int getHours();
  //
  // Get total cooling time (minutes only).
  //
  int getMinutes();*/
  //
  // Calculate using the lower voltages (220V to 230V as defined by ISO).
  //
  double calculateLow(int voltage);
  //
  // Calculate using the higher voltages (380V to 400V as defined by ISO).
  //
  double calculateHigh(int voltage);
  //
  // Find out the total amount of time necessary to cool down an industrial-sized
  // milk tank.
  //
  double calculate(int voltage);
}
