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
import 'package:oldairy/classes/tformatter.dart';

void main() {
  //
  // Test time rounding on `get`.
  //
  test('[NEG] Given time is negative', () {
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
  });

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
