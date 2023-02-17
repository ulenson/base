import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../service/fire_base_helper.dart';

const url =
    'https://us-central1-stripe-85862.cloudfunctions.net/stripePaymentIntentRequest';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var username = '';
  var paid = false;
  var notes = <String>[];

  @override
  void initState() {
    super.initState();
    _initUsername();
    _initData();
    observeSubscriptionState();
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
        body:
        paid ? _notes: _pay,
    );
  }
        // Padding(
      //   padding: const EdgeInsets.all(30.0),
      //   child: Column(
      //     children: [
      //       Center(
      //         child: Text(
      //           'Привет, $username!',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 20,
      //           ),
      //         ),
      //       ),

            // SizedBox(
            //   height: 10,
            // ),
            // ElevatedButton(
            //   onPressed: () => initPaymentSheet(context,
            //       email: "example@gmail.com", amount: 100),
            //   child: const Text(
            //     'Оплата подписки',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),

  Future _initData() async {
    FirebaseHelper.getNotes().listen((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map != null) {
        setState(() {
          notes = map.values.map((e) => e as String).toList();
        });
      }
    });
  }




  Widget get _notes =>
        Expanded(
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, i) => ListTile(
              trailing: Wrap(
                spacing: 12,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ],
              ),
              title: Text(notes[i]),
              onTap: () => FirebaseHelper.removeNote(notes[i]),
            ),
          ),
        );

  Widget get _pay =>
     ElevatedButton(
      onPressed: () =>
          initPaymentSheet(context, email:FirebaseHelper.getEmail() ?? "example@gmail.com", amount: 100),
      child: const Text(
        'Оплата подписки',
        style: TextStyle(color: Colors.white),
      ),
    );

  Future write() async {
    await FirebaseHelper.isSubscribed();
  }

  Future<void> _initUsername() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    setState(() {
      username = email;
    });
  }

  Future<void> initPaymentSheet(context,
      {required String email, required int amount}) async {
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
            url,
          ),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());

      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment completed!')),
      );
      await FirebaseHelper.isSubscribed();
    } catch (e) {
      log(e.toString());
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
  Future observeSubscriptionState() async {
    await Future.delayed(const Duration(seconds: 1));
    FirebaseHelper.subscriptionState().listen((event) {
      final state = event.snapshot.value;
      if (state == null) return;
      final success = (state as bool?);
      if (success == null) return;
      setState(() {
        paid = success;
      });
    });
  }

}
