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

	Description: general app information located within a single route.

*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oldairy/classes/settings.dart';

class AboutRoute extends StatefulWidget {
  const AboutRoute({
    super.key,
    required this.title,
    required this.settings,
  });

  final String title;
  final Settings settings;

  @override
  State<AboutRoute> createState() => _AboutRouteState();
}

class _AboutRouteState extends State<AboutRoute> {
  final double edgeInsetsSize = 25;

  Padding getPackageName() {
    return Padding(
      padding: EdgeInsets.all(edgeInsetsSize),
      child: const Text(
        'Oldairy',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding getPackageVersion() {
    return Padding(
      padding: EdgeInsets.all(edgeInsetsSize),
      child: Text(
        'Version ${widget.settings.packageVersion}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding getPackageDescription() {
    return Padding(
      padding: EdgeInsets.all(edgeInsetsSize),
      child: const Text(
        'A simple calculator for finding out the approximate cooling time of a typical industrial-sized milk tank.',
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding getPackageAddress() {
    return Padding(
      padding: EdgeInsets.all(edgeInsetsSize),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Development:',
        ),
        controller: TextEditingController(
          text: 'https://github.com/sapientlion/oldairy',
        ),
        readOnly: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding getPackageLicense() {
    return Padding(
      padding: EdgeInsets.all(edgeInsetsSize),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'License: GNU General Public License Version 3',
        ),
        controller: TextEditingController(
          text: 'https://github.com/sapientlion/oldairy/blob/master/LICENSE',
        ),
        readOnly: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding getPackageCopyrightNotice() {
    return Padding(
      padding: EdgeInsets.all(edgeInsetsSize),
      child: const Text(
        'Oldairy Copyright (C) 2023 - 2024 Leo `SapientLion` Markoff',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8.0,
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getPackageName(),
              getPackageVersion(),
              getPackageDescription(),
              getPackageAddress(),
              getPackageLicense(),
              // Hopefully, no one would see this, but i'm actually a turtle.
              getPackageCopyrightNotice(),
            ],
          ),
        ),
      ),
    );
  }
}
