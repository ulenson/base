import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/fire_base_helper.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход в аккаунт'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'адрес электронной почты'),
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'пароль'),
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                final success = await FirebaseHelper.login(email, password);
                if (success) {
                  Navigator.pushReplacementNamed(context, '/profile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Wrong email or password'),
                    ),
                  );
                }
    },

              child: const Text('Войти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_up');
              },
              child: const Text('Нет аккаунта? Зарегистрируйтесь!'),
            ),
            TextButton(
              onPressed: () =>
              {
                Navigator.pushNamed(context, '/forgot'),
              },
              child: const Text('Забыли пароль?'),
            ),
          ],
        ),
      ),
    );
  }
}