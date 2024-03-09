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
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();

    _widgets.add(_getPackageInfo());
    _widgets.add(_getPackageDescription());
    _widgets.add(_getTechnicalDetails());
    _widgets.add(_getCopyrightInfo());
  }

  ///
  /// Generic text widget generator.
  ///
  Text _get({required String data, TextStyle? style}) {
    return Text(
      data,
      style: style,
      textAlign: TextAlign.center,
    );
  }

  ///
  /// Get copyright details.
  ///
  Text _getCopyrightInfo() {
    return _get(data: 'Oldairy Copyright © 2023 - 2024 Leo `SapientLion` Markoff');
  }

  ///
  /// Get project license.
  ///
  Future<void> _getLicenseInfo() async {
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
  Text _getPackageDescription() {
    return _get(
        data:
            'A simple calculator for finding out the approximate cooling time of a typical industrial-sized milk tank.');
  }

  ///
  /// Get general project information.
  ///
  Column _getPackageInfo() {
    return Column(
      children: [
        _get(
          data: 'Oldairy',
          style: const TextStyle(fontSize: 30.0),
        ),
        _get(
          data: 'Version ${widget.settings.packageVersion}',
        ),
      ],
    );
  }

  ///
  /// Get all technical information on this project.
  ///
  Column _getTechnicalDetails() {
    return Column(
      children: [
        TextButton.icon(
          icon: const Icon(Icons.account_tree),
          onPressed: () {
            bool result = _launchGitHub() as bool;

            if (!result) {
              _getUnavailableResourceAlertBox();
            }

            return;
          },
          label: const Text('Visit project on GitHub'),
        ),
        TextButton.icon(
          icon: const Icon(Icons.book),
          onPressed: () {
            _getLicenseInfo();

            return;
          },
          label: const Text('License: GNU GPL Version 3'),
        ),
      ],
    );
  }

  ///
  /// Show dialog window on web resource request fail.
  ///
  void _getUnavailableResourceAlertBox() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Requested web resource is not available. Try again later.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();

                return;
              },
            ),
          ],
        );
      },
    );
  }

  ///
  /// Invoke internet page to see more information on this project.
  ///
  Future<bool> _launchGitHub() async {
    Uri url = Uri.parse('https://gefwefwefwefweion/oldairy');

    if (!await launchUrl(url)) {
      return false;
    }

    return true;
  }
}
