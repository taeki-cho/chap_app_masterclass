import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // 로그인 정보 instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 로그인
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // 회원가입

  // 로그아웃
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // 에러
}
