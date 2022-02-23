import 'package:creative_movers/helpers/extension.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/auth/widgets/signup_form.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                    child: Image(
                  image: AssetImage(
                    AppIcons.icSplashLogo,
                  ),
                  height: 150,
                  width: 150,
                )),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  context.localization.createAccount,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const SignupForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
