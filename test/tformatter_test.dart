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
  test('[NEG] Given time is negative', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: -11.123123);

    expect(timeFormatter.get(), -11.123123);
  });

  test('[NEG] Given time is equal to zero', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 0.0);

    expect(timeFormatter.get(), 0.0);
  });

  test('[POS] Given time is correct', () {
    TimeFormatter timeFormatter = TimeFormatter(cTime: 11.123123);

    expect(timeFormatter.get(), 13.34);
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
