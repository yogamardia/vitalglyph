import 'dart:async';

import 'package:flutter/services.dart';

/// Handles `.medid` files opened from outside the app (e.g. email, AirDrop,
/// file manager). Platform code sends the file path through a [MethodChannel].
class IncomingFileService {
  static const _channel = MethodChannel('com.example.vitalglyph/file_open');

  final _controller = StreamController<String>.broadcast();
  String? _pendingFilePath;

  /// Stream that emits a file path each time a `.medid` file is opened.
  Stream<String> get onFileOpen => _controller.stream;

  IncomingFileService() {
    _channel.setMethodCallHandler(_handlePlatformCall);
  }

  /// Call once after DI is ready to check whether the app was cold-launched
  /// with a `.medid` file.
  Future<void> checkInitialFile() async {
    try {
      final path = await _channel.invokeMethod<String>('getInitialFile');
      if (path != null && path.isNotEmpty) {
        _pendingFilePath = path;
        _controller.add(path);
      }
    } on PlatformException {
      // Platform doesn't support this (e.g. desktop) — ignore.
    } on MissingPluginException {
      // No native handler registered — ignore.
    }
  }

  /// Returns and clears the pending file path, if any.
  /// Called by [BackupScreen] to pre-populate the import form.
  String? consumePendingFile() {
    final path = _pendingFilePath;
    _pendingFilePath = null;
    return path;
  }

  Future<dynamic> _handlePlatformCall(MethodCall call) async {
    if (call.method == 'onFileOpen') {
      final path = call.arguments as String;
      _pendingFilePath = path;
      _controller.add(path);
    }
  }

  void dispose() {
    _controller.close();
  }
}
