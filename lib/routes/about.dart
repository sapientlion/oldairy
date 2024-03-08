/*

    Oldairy - a simple calculator for finding out the approximate
	  cooling time of a typical industrial-sized milk tank.
	  Hopefully, no one would see this, but i'm actually a turtle.
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

	  Description: project info and its technical details.

*/

import 'package:flutter/material.dart';
import 'package:oldairy/classes/global.dart';
import 'package:oldairy/classes/settings.dart';

import 'license.dart';

class AboutRoute extends StatefulWidget {
  final String title;

  final Settings settings;

  const AboutRoute({
    super.key,
    required this.title,
    required this.settings,
  });

  @override
  State<AboutRoute> createState() => _AboutRouteState();
}

class _AboutRouteState extends State<AboutRoute> {
  final List<Widget> _widgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: Global.defaultScrollbarThickness,
        child: ListView.separated(
          itemCount: _widgets.length,
          itemBuilder: (BuildContext context, int index) {
            return _widgets.elementAt(index);
          },
          padding: Global.defaultEdgeInsets,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.black,
              height: 110.0,
            );
          },
          shrinkWrap: true,
        ),
      ),
    );
  }

  ///
  /// Generic text widget generator.
  ///
  Text get({required String data, TextStyle? style}) {
    return Text(
      data,
      style: style,
      textAlign: TextAlign.center,
    );
  }

  ///
  /// Get copyright details.
  ///
  Text getCopyrightInfo() {
    return get(data: 'Oldairy Copyright © 2023 - 2024 Leo `SapientLion` Markoff');
  }

  ///
  /// Get project license.
  ///
  Future<void> getLicenseInfo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LicenseRoute(
          title: 'License',
        ),
      ),
    );

    return;
  }

  ///
  /// Get project description.
  ///
  Text getPackageDescription() {
    return get(
        data:
            'A simple calculator for finding out the approximate cooling time of a typical industrial-sized milk tank.');
  }

  ///
  /// Get general project information.
  ///
  Column getPackageInfo() {
    return Column(
      children: [
        get(
          data: 'Oldairy',
          style: const TextStyle(fontSize: 30.0),
        ),
        get(
          data: 'Version ${widget.settings.packageVersion}',
        ),
      ],
    );
  }

  ///
  /// Get all technical information on this project.
  ///
  Column getTechnicalDetails() {
    return Column(
      children: [
        TextButton.icon(
          icon: const Icon(Icons.account_tree),
          onPressed: () {
            return;
          },
          label: const Text('Visit project on GitHub'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.book),
          onPressed: () {
            getLicenseInfo();

            return;
          },
          label: const Text('License: GNU GPL Version 3'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _widgets.add(getPackageInfo());
    _widgets.add(getPackageDescription());
    _widgets.add(getTechnicalDetails());
    _widgets.add(getCopyrightInfo());
  }
}
