import 'package:base/screens/fogot_password_screen.dart';
import 'package:base/screens/login_screen.dart';
import 'package:base/screens/profile_screen.dart';
import 'package:base/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:base/screens/fogot_password_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/sign_up': (_) => SignUpScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/forgot': (_) => ForgotPass(),
      },
    );
  }
}
