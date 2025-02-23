import 'package:flutter/material.dart';
import 'package:vocary/app.dart';
import 'startup.dart';

void main() async {
  const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  await Startup.initialize(env: flavor);
  runApp(const App());
}
