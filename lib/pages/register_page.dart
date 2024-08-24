import 'package:chap_app_masterclass/services/auth/auth_service.dart';
import 'package:chap_app_masterclass/components/my_button.dart';
import 'package:chap_app_masterclass/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // 로그인 페이지 이동
  final void Function()? onTap;

  // login 함수
  void register(BuildContext context) async {
    final auth = AuthService();

    // 패스워드가 동일한지 체크
    if (_pwController.text == _confirmPwController.text) {
      try {
        await auth.singUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
    // 패스워드가 동일하지 않으면 에러
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("패스워드가 일치하지 않습니다."),
        ),
      );
    }
  }

  RegisterPage({super.key, required this.onTap});

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
              "Let's create an account for you",
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
              height: 10,
            ),
            // 패스워드 확인
            MyTextfield(
              hindText: "Confirm Password",
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(
              height: 25,
            ),
            // 로그인 버튼
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 25,
            ),
            // 등록자
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
