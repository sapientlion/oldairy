import 'package:flutter/material.dart';

class AboutRoute extends StatefulWidget {
  const AboutRoute({super.key, required this.title});

  final String title;

  @override
  State<AboutRoute> createState() => _AboutRouteState();
}

class _AboutRouteState extends State<AboutRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: null,
    );
  }
}
