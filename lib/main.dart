import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'injector/injector.dart';
import 'my_profile_app.dart';

/// Entry point of the program
void main() async {
  /// Runs the program in its own error zone
  await runZonedGuarded(() async {
    /// Ensuring that framework is binds with the engine
    WidgetsFlutterBinding.ensureInitialized();

    /// Setup the service locator
    await Injector.setup();

    /// Attaching the App
    runApp(const MyProfileApp());
  }, (error, stackTrace) async {
    if (kReleaseMode) {
      /// Add Crashlytics here when needed
    } else {
      dev.log('runZonedGuarded error: ${error.toString()}');
    }
  });
}
