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

	Description: the about route.

*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:url_launcher/url_launcher.dart';

class AboutRoute extends StatefulWidget {
  const AboutRoute({super.key, required this.title});

  final String title;

  @override
  State<AboutRoute> createState() => _AboutRouteState();
}

class _AboutRouteState extends State<AboutRoute> {
  String packageVersion = '';

  /*Future<void> tryUrl() async {
    Uri url = Uri.parse('https://github.com/sapientlion/oldairy/blob/master/LICENSE');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        packageVersion = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Oldairy',
                  textScaleFactor: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Version $packageVersion',
                  textScaleFactor: 2,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'A simple calculator for finding out the approximate cooling time of a typical industrial-sized milk tank.',
                  textScaleFactor: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Development:'),
                  controller: TextEditingController(text: 'https://github.com/sapientlion/oldairy'),
                  readOnly: true,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'License: GNU General Public License Version 3'),
                  controller: TextEditingController(text: 'https://github.com/sapientlion/oldairy/blob/master/LICENSE'),
                  readOnly: true,
                  textAlign: TextAlign.center,
                ),
              ),
              // Hopefully, no one would see this, but i'm actually a turtle.
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Oldairy Copyright (C) 2023 Leo `Sapientlion` Markoff',
                  textAlign: TextAlign.center,
                ),
              ),
              /*Padding(
              padding: const EdgeInsets.all(24),
              child: InkWell(
                onTap: () {
                  tryUrl();
                },
                child: const Text(
                  'License: GNU General Public License Version 3',
                  textAlign: TextAlign.center,
                ),
              ),
            ),*/
            ],
          ),
        ),
      ),
    );
  }
}
