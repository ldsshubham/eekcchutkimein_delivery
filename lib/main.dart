import 'package:eekcchutkimein_delivery/app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    debugPrint('DIAGNOSTIC: Flutter Framework Error: ${details.exception}');
    debugPrint('DIAGNOSTIC: Stack trace: ${details.stack}');
  };

  try {
    debugPrint('DIAGNOSTIC: Starting GetStorage init');
    await GetStorage.init();
    debugPrint('DIAGNOSTIC: GetStorage init complete');

    debugPrint('DIAGNOSTIC: Running MyApp');
    runApp(MyApp());
  } catch (e, stack) {
    debugPrint('DIAGNOSTIC: Stack trace: $stack');
  }
}
