import 'package:chap_app_masterclass/auth/auth_gate.dart';
import 'package:chap_app_masterclass/auth/login_or_register.dart';
import 'package:chap_app_masterclass/firebase_options.dart';
import 'package:chap_app_masterclass/pages/login_page.dart';
import 'package:chap_app_masterclass/pages/register_page.dart';
import 'package:chap_app_masterclass/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}
