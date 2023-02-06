import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../service/fire_base_helper.dart';
class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var username = '';

  @override
  void initState() {
    super.initState();
    _initUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
        actions: [
          TextButton(
            onPressed: () async {
              FirebaseHelper.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Выйти',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Привет, $username!')),
        ],
      ),
    );
  }

  Future<void> _initUsername() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    setState(() {
      username = email;
    });
  }
}