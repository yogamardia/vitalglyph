import 'package:flutter/material.dart';
import 'package:vitalglyph/app.dart';
import 'package:vitalglyph/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
