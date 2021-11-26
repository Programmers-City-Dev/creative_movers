import 'package:flutter/material.dart';

import 'form_field.dart';
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email Address'),
          const SizedBox(height: 10,),
          CustomTextField(validator:(d){},icon: Icons.mail_rounded, hint: 'Email Address',),
          const SizedBox(height: 16,),

          const Text('Password'),
          const SizedBox(height: 10,),
          const CustomTextField(icon: Icons.lock, hint: 'Password',),
        ],
      ),
    );
  }
}
