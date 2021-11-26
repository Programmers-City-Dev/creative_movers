import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/auth/widgets/form_field.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return Form(child:
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        const SizedBox(height: 30,),

        const SizedBox(height: 10,),
        const CustomTextField(icon: Icons.person, hint: 'Username',),
        const SizedBox(height: 16,),


        const SizedBox(height: 10,),
         CustomTextField(validator:(d){},icon: Icons.mail_rounded, hint: 'Email',),
        const SizedBox(height: 16,),

        const SizedBox(height: 10,),
        const CustomTextField(icon: Icons.lock, hint: 'Password',),
        const SizedBox(height: 30,),
        const Center(child: CustomButton()),
        const SizedBox(height: 30,),
        Center(
          child: RichText(
              text: TextSpan(children: [
                const TextSpan(
                    text: 'Already have an account  ?  ',
                    style: TextStyle(
                      color: Colors.black
                        )),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                  text: 'Login',
                  style: const TextStyle(
                      color:AppColors.primaryColor,
                      decoration: TextDecoration.underline),
                ),
              ])),
        ),
      ],
    ));
  }
}
