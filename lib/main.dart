import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lenses/app.dart';
import 'package:lenses/services/di_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await diRegisters();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
  );
  runApp(const App());
}
