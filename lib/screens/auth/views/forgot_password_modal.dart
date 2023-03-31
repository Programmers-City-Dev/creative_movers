import 'dart:developer';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/screens/auth/views/confirm_token_form.dart';
import 'package:creative_movers/screens/auth/views/forgot_password_form.dart';
import 'package:creative_movers/screens/auth/views/reset_password_form.dart';
import 'package:flutter/material.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({Key? key, required this.onComplete})
      : super(key: key);
  final VoidCallback onComplete;

  @override
  _ForgotPasswordModalState createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> with SingleTickerProviderStateMixin {
  String screen = 'forgot password';
  String userEmail = '';

 late TabController _controller;
@override
  void initState() {
  _controller = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   // controller: _controller,
    //   children:  [
    //     ForgotPasswordForm(onFinish: (){_controller.animateTo(1, duration: Duration(), curve:Curves.ease );}),
    //     // ConfirmTokenForm(onFinish: (){}),
    //     // ResetPasswordForm(onFinish: (){})
    //
    //   ],
    // );

    return Container(
      child: screen == 'forgot password'
          ? ForgotPasswordForm(
              onFinish: (email) {
                setState(() {
                  userEmail = email;
                  screen = 'digit code';
                  log('message');
                });
              },
            )
          : screen == 'digit code'
              ? ConfirmTokenForm(
                  onFinish: () {
                    setState(() {
                      screen = '';
                    });
                  }, email: userEmail,
                )
              : ResetPasswordForm(
                  onFinish: (){
                    widget.onComplete();
                  }, email: userEmail,
                ),
    );
  }

  void _listenToAuthBlocState(BuildContext context, AuthState state) {
    // if (state is )
  }
}
