import 'package:app_mobile/full.dart';
import 'package:flutter/material.dart';

class less extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: full(),
    );
  }
}