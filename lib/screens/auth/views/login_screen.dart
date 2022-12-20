import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/auth/widgets/login_form.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                height: kToolbarHeight * 2,
              ),
              Center(
                  child: Image(
                image: AssetImage(
                  AppIcons.icSplashLogo,
                ),
                height: 150,
                width: 150,
              )),
              SizedBox(
                height: 16,
              ),
              Text(
                'Signin',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 50,
              ),
              LoginForm()
            ],
          ),
        ),
      ),
    );
  }
}
