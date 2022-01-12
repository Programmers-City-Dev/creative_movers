import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/auth/views/more_details_screen.dart';
import 'package:creative_movers/screens/auth/widgets/form_field.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

        CustomTextField(icon: Icons.person, hint: AppLocalizations.of(context)!.username,),
        const SizedBox(height: 16,),


         CustomTextField(validator:(d){},icon: Icons.mail_rounded, hint: AppLocalizations.of(context)!.email,),
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
          icon: Icons.lock, hint: AppLocalizations.of(context)!.password,),
        const SizedBox(height: 30,),
         Center(child: CustomButton( onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoreDetailsScreen(),));
         },
         child:  Row(
          mainAxisSize: MainAxisSize.min,
          children:  [
            const Icon(
              Icons.logout_outlined,
            ),
            const SizedBox(width: 5,),
            Text(AppLocalizations.of(context)!.signUp)
          ],
        ),)),
        const SizedBox(height: 30,),
        Center(
          child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: AppLocalizations.of(context)!.alreadyHasAnAccountText,
                    style: const TextStyle(
                      color: Colors.black
                        )),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                  text: AppLocalizations.of(context)!.login,
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
