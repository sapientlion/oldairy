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

	Description: `Calculator` tester.

*/

import 'package:flutter_test/flutter_test.dart';
import 'package:oldairy/classes/calculator.dart';

void main() {
  //
  // Low voltage calculations.
  //
  test('[NEG] Using a low voltage, `initialTemp` and `setTemp` subtraction is equal to zero', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 11.0,
      volume: 100.0,
      voltage: 220,
      ampsFirstWire: 4.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0,
    );

    expect(calculator.calculate(220), 0.0);
  });

  test('[NEG] Using a low voltage, voltage is equal to zero (simulate division by zero)', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 0,
      ampsFirstWire: 4.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0,
    );

    expect(calculator.calculate(0), 0.0);
  });

  test('[NEG] Using a low voltage, amperage is equal to zero (simulate division by zero)', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 220,
      ampsFirstWire: 0.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0,
    );

    expect(calculator.calculate(220), 0.0);
  });

  test('[POS] Using a low voltage, get adequate result', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 220,
      ampsFirstWire: 4.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0,
    );

    expect(calculator.calculate(220), 0.47);
  });

  //
  // High voltage calculations.
  //
  test('[NEG] Using a high voltage, `initialTemp` and `setTemp` subtraction is equal to zero', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 11.0,
      volume: 100.0,
      voltage: 380,
      ampsFirstWire: 4.0,
      ampsSecondWire: 4.0,
      ampsThirdWire: 4.0,
    );

    expect(calculator.calculate(380), 0.0);
  });

  test('[NEG] Using a high voltage, voltage is equal to zero (simulate division by zero)', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 0,
      ampsFirstWire: 4.0,
      ampsSecondWire: 4.0,
      ampsThirdWire: 4.0,
    );

    expect(calculator.calculate(0), 0.0);
  });

  test('[NEG] Using a high voltage, all amperages are equal to zero (simulate division by zero)', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 380,
      ampsFirstWire: 0.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0,
    );

    expect(calculator.calculate(380), 0.0);
  });

  test('[NEG] Using a high voltage, first amperage is equal to zero (simulate division by zero)', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 380,
      ampsFirstWire: 0.0,
      ampsSecondWire: 4.0,
      ampsThirdWire: 4.0,
    );

    expect(calculator.calculate(380), 0.0);
  });

  test('[POS] Using a high voltage, get adequate result without the inclusion of the second wire', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 380,
      ampsFirstWire: 4.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 4.0,
    );

    expect(calculator.calculate(380), 0.23);
  });

  test('[POS] Using a high voltage, get adequate result without the inclusion of the third wire', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 380,
      ampsFirstWire: 4.0,
      ampsSecondWire: 4.0,
      ampsThirdWire: 0.0,
    );

    expect(calculator.calculate(380), 0.23);
  });

  test('[POS] Using a high voltage, get adequate result', () {
    Calculator calculator = Calculator(
      initialTemp: 11.0,
      setTemp: 5.0,
      volume: 100.0,
      voltage: 380,
      ampsFirstWire: 4.0,
      ampsSecondWire: 4.0,
      ampsThirdWire: 4.0,
    );

    expect(calculator.calculate(380), 0.16);
  });
}
