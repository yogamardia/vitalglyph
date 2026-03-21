import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vitalglyph/app.dart';
import 'package:vitalglyph/core/services/incoming_file_service.dart';
import 'package:vitalglyph/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  unawaited(sl<IncomingFileService>().checkInitialFile());
  runApp(const App());
}
