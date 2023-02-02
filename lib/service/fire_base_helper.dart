import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:base/screens/forgot_password_screen.dart';
class FirebaseHelper {

  static Future<bool> login(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // Код ошибка для случая, если пользователь не найден
      if (e.code == 'user-not-found') {
        print("Unknown user");
        // Код ошибка для случая, если пользователь ввёл неверный пароль
      } else if (e.code == 'wrong-password') {
        print("Wrong password");
      }
    } catch (e) {
      print("Unknown error");
    }
    return false;
  }





  static Future<bool> signUp(String email, String password) async {
    try {
      // UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email address.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future resetPassword(String email) async {
    final emailController = TextEditingController();
    final email = emailController.text.trim();
    try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email);
        // emailController.text);
        // 'oulitka75@gmail.com');

  } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        print('Неверный адрес');
      }
      print(e);
      print(email);
    }

  }


static Future<void> logout

() async
{await FirebaseAuth.instance.signOut();

}
}