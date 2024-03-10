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

	  Description: define a driver method.

*/

import 'package:flutter/material.dart';
import 'package:oldairy/routes/home.dart';

void main() {
  runApp(
    const Oldairy(),
  );
}

class Oldairy extends StatelessWidget {
  final String _homeTitle = 'Home';

  const Oldairy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _homeTitle,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(0, 128, 0, 1.0),
          foregroundColor: Colors.white,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color.fromRGBO(0, 128, 0, 1),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(
            Colors.lightGreen,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            disabledBackgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide.none,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          counterStyle: TextStyle(height: double.minPositive),
          filled: true,
          fillColor: Color.fromRGBO(211, 211, 211, 1),
          focusColor: Colors.green,
          floatingLabelStyle: TextStyle(
            color: Colors.black,
          ),
          helperStyle: TextStyle(
            color: Colors.black,
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,
        ),
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.lightGreen,
          ),
        ),
      ),
      home: HomeRoute(
        title: _homeTitle,
      ),
    );
  }
}
