import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../service/fire_base_helper.dart';
class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Сбросить пароль'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Получить письмо для сброса пароля'),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Верный адрес электронной почты'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  maximumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.email_outlined),
                label: Text('Изменить пароль'),
                onPressed:() {
                  FirebaseHelper.resetPassword();
                  // Navigator.pop(context);
                },

              ),



            ],
          ),
        ),
      ),
    );

    // Future resetPassword() async {
    //   // showDialog(
    //   //   context: context,
    //   //   barrierDismissible: false,
    //   //   builder: (context) =>
    //   //       Center(
    //   //           child: CircleProgressIndicator()),
    //   // );
    //   try {
    //     await FirebaseAuth.instance.sendPasswordResetEmail(
    //         email: emailController.text);
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.red,
    //       content: Text('Новый пароль отправлен на почту'),
    //     ),
    //
    //     );
    //     Navigator.of(context).popUntil((route) => route.isFirst);
    //   } on FirebaseAuthException catch (e) {
    //     print(e);
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.red,
    //       content: Text(e.message),),
    //     );
    //   }
    // }
  }
}