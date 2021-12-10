import 'package:creative_movers/screens/auth/views/forgot_password_modal.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/auth/views/signup_screen.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);


  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomTextField(validator: (d) {},
            icon: Icons.mail_rounded,
            hint: 'Email Address',),
          const SizedBox(height: 16,),

           CustomTextField(

            toggle_icon: IconButton(onPressed: (){
              setState(() {
                obscure = !obscure;
              });
            }, icon:obscure ?
             const Icon( Icons.visibility_off_outlined,color: AppColors.textColor,):const Icon(Icons.visibility_outlined,color: AppColors.textColor,),
            ),
            obscure: obscure,
            icon: Icons.lock, hint: 'Password',),
          const SizedBox(height: 20,),
           CustomButton(onTap: () {

             Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
           },
           child:  Row(
            mainAxisSize: MainAxisSize.min,
            children:  const [
              Icon(
                Icons.logout_outlined,
              ),
              SizedBox(width: 5,),
              Text('Login')
            ],
          ),),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  shape:  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                      isScrollControlled: true,
                    context: context,
                    builder: (_) => ForgotPasswordModal());

              },
              child: Text(
                'Forgot Password',
                textAlign: TextAlign.end,),
            ),
          ),
          const SizedBox(height: 50,),

          Center(
            child: RichText(
                text: TextSpan(children: [
                  const TextSpan(
                      text: 'I dont have an account  ?  ',
                      style: TextStyle(
                          color: Colors.black
                      )),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ));
                      },
                    text: 'SignUp',
                    style: const TextStyle(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ])),
          )
        ],
      ),
    );
  }
}
