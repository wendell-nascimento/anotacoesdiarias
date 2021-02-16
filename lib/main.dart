import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green,
          accentColor: Colors.green,
        ),
    home: Home(),
  ));
}
