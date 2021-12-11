import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/auth/views/more_details_screen.dart';
import 'package:creative_movers/screens/auth/widgets/form_field.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Form(child:
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        const SizedBox(height: 30,),

        const CustomTextField(icon: Icons.person, hint: 'Username',),
        const SizedBox(height: 16,),


         CustomTextField(validator:(d){},icon: Icons.mail_rounded, hint: 'Email',),
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
        const SizedBox(height: 30,),
         Center(child: CustomButton( onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoreDetailsScreen(),));
         },
         child:  Row(
          mainAxisSize: MainAxisSize.min,
          children:  const [
            Icon(
              Icons.logout_outlined,
            ),
            SizedBox(width: 5,),
            Text('Sign Up')
          ],
        ),)),
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
