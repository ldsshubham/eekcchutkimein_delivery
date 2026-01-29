import 'package:eekcchutkimein_delivery/app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    debugPrint('Flutter Framework Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  try {
    debugPrint('Starting GetStorage init');
    await GetStorage.init();
    debugPrint('GetStorage init complete');

    debugPrint('Running MyApp');
    runApp(MyApp());
  } catch (e, stack) {
    debugPrint('t: Stack trace: $stack');
  }
}
