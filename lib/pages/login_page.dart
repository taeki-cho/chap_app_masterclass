import 'package:chap_app_masterclass/components/my_button.dart';
import 'package:chap_app_masterclass/components/my_textfield.dart';
import 'package:chap_app_masterclass/themes/light_mode.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // login 함수
  void login() {}

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 50,
            ),
            // 환영 인사
            Text(
              "Welcome bacl, you're been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // 이메일 입력
            MyTextfield(
              hindText: "E-mail",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            // 패스워드 입력
            MyTextfield(
              hindText: "Password",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(
              height: 25,
            ),
            // 로그인 버튼
            MyButton(
              text: "LogIn",
              onTap: login,
            ),
            const SizedBox(
              height: 25,
            ),
            // 등록자
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  "Register now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
