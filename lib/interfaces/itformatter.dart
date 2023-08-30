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

	Description: time formatter interface.

*/

abstract class ITimeFormatter {
  //
  // Get cooling time.
  //
  double get(bool rFlag);
  //
  // Get fraction of the given number.
  //
  int getFraction(String value);
  //
  // Get cooling time (minutes).
  //
  int getHours(bool rFlag);
  //
  // Get cooling time (minutes).
  //
  int getMinutes(bool rFlag, {bool mpmFlag = true});
  //
  // Round cooling time.
  //
  double round({bool mpmFlag = true});
}
