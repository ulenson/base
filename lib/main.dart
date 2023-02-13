import 'package:base/screens/forgot_password_screen.dart';
import 'package:base/screens/login_screen.dart';
import 'package:base/screens/profile_screen.dart';
import 'package:base/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:base/screens/forgot_password_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51Mb4UeL4wGVBAypjKi9uCkgmxwTWItU2U4NIBs0JDoGO4G6CG0AKtdWp2c7ZHIPvPSKe0WkomT3DSChNqhl1nTlb00g452MGDS";
  await Stripe.instance.applySettings();
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
        '/forgot': (_) => const ForgotPass(),
      },
    );
  }
}
