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

	Description: TimeFormatter tester.

*/

import 'package:flutter_test/flutter_test.dart';
import 'package:oldairy/classes/calculator.dart';
import 'package:oldairy/classes/tformatter.dart';

void main() {
  Calculator calcZero = Calculator(
      initialTemp: 0.0,
      targetTemp: 0.0,
      volume: 0.0,
      voltage: 0.0,
      ampsFirstWire: 0.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0);
  Calculator calc = Calculator(
      initialTemp: 64.0,
      targetTemp: -64.0,
      volume: 100.0,
      voltage: 220.0,
      ampsFirstWire: 4.0,
      ampsSecondWire: 0.0,
      ampsThirdWire: 0.0);

  //
  // Test time rounding on `get`.
  //
  test('[NEG] Given time is equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calcZero);

    expect(timeFormatter.get(true), 0.0);
  });

  test('[POS] Get raw cooling time', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(timeFormatter.get(true), 9.963636363636363);
  });

  //
  // Test time rounding on `getHours`.
  //
  test('[NEG] Given hours are equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calcZero);

    expect(timeFormatter.getHours(), 0);
  });

  test('[POS] Given hours are in correct format', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(timeFormatter.getHours(), 9);
  });

  //
  // Test time rounding on `getMinutes`.
  //
  test('[NEG] Given minutes are equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calcZero);

    expect(timeFormatter.getMinutes(), 0);
  });

  test('[POS] Get minutes from total cooling time, but do not convert the minutes from decimals', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(timeFormatter.getMinutes(rFlag: false), 96);
  });

  test('[POS] Get minutes from total cooling time, but do not round minutes up', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(timeFormatter.getMinutes(pFlag: false), 57);
  });

  test('[POS] Get minutes from total cooling time, but do round minutes up', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(timeFormatter.getMinutes(pFlag: true), 58);
  });

  /*test('[NEG] Given hours are equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calcZero);

    expect(timeFormatter.getHours(true), 0);
  });

  test('[POS] Given hours are in correct format', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(timeFormatter.getHours(true), 9);
  });

  //
  // Test time rounding on `getMinutes`.
  //
  test('[NEG] Given minutes are equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calcZero);

    expect(timeFormatter.getMinutes(true), 0);
  });

  test('[POS] Resulting minutes are correct, but left untouched', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(
        timeFormatter.getMinutes(
          true,
          mpmFlag: false,
        ),
        57);
  });

  test('[POS] Resulting minutes are correct, but were rounded for more precision', () {
    TimeFormatter timeFormatter = TimeFormatter(calculator: calc);

    expect(timeFormatter.getMinutes(true), 57);
  });*/

  /*test('[NEG] Given time is negative', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: -11.123123);

    expect(timeFormatter.get(true), -11.123123);
  });

  test('[NEG] Given time is equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 0.0);

    expect(timeFormatter.get(true), 0.0);
  });

  test('[POS] Given time is correct', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 11.123123);

    expect(timeFormatter.get(true), 13.35);
  });

  //
  // Test time rounding on `getHours`.
  //
  test('[NEG] Given hours are negative', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: -11.123123);

    expect(timeFormatter.getHours(true), -11);
  });

  test('[NEG] Given hours are equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 0.0);

    expect(timeFormatter.getHours(true), 0);
  });

  test('[POS] Given hours are in correct format', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 11.123123);

    expect(timeFormatter.getHours(true), 13);
  });

  //
  // Test time rounding on `getMinutes`.
  //
  test('[NEG] Given minutes are negative', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: -11.123123);

    expect(timeFormatter.getMinutes(true), 0);
  });

  test('[NEG] Given minutes are equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 0.0);

    expect(timeFormatter.getMinutes(true), 0);
  });

  test('[POS] Resulting minutes are correct, but left untouched', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 11.123123);

    expect(
        timeFormatter.getMinutes(
          true,
          mpmFlag: false,
        ),
        34);
  });

  test('[POS] Resulting minutes are correct, but were rounded for more precision', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 11.123123);

    expect(timeFormatter.getMinutes(true), 35);
  });*/

  /*testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/
}
