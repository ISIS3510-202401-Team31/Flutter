import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:unifood/repository/error_repository.dart';
import 'package:unifood/repository/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:unifood/utils/routes.dart';

List<Map<String, dynamic>> errores = [];

void main() async {
  //Firebase connection
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //SharedPreferences
  await SharedPreferencesService.getInstance();

  //Error handling
  FlutterError.onError = (errorDetails) {
    final errorInfo = {
      'error': errorDetails.toString(),
      'stacktrace': errorDetails.stack.toString(),
      'timestamp': DateTime.now(),
    };
    ErrorRepository().saveError(errorInfo);
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    final errorInfo = {
      'error': error.toString(),
      'stacktrace': stack.toString(),
      'timestamp': DateTime.now(),
    };
    ErrorRepository().saveError(errorInfo);
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
