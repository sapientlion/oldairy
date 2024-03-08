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

	  Description: license route.

*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/global.dart';

class LicenseRoute extends StatefulWidget {
  final String title;

  const LicenseRoute({super.key, required this.title});

  @override
  State<LicenseRoute> createState() => _LicenseRouteState();
}

class _LicenseRouteState extends State<LicenseRoute> {
  String _license = 'N/a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: Global.defaultScrollbarThickness,
        child: SingleChildScrollView(
          padding: Global.defaultEdgeInsets,
          child: Text(
            _license,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    String contents = '';

    read().then(
      (value) async => {
        setState(() {
          _license = value;
        })
      },
    );

    return;
  }

  Future<String> read() async {
    return await rootBundle.loadString('assets/license.txt');
  }
}
