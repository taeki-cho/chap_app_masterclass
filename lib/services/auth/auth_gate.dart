import 'package:chap_app_masterclass/services/auth/login_or_register.dart';
import 'package:chap_app_masterclass/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 사용자 로그인 상태
          if (snapshot.hasData) {
            return HomePage();
          }
          // 사용자 로그아웃 상태
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
