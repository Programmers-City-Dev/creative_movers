import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/onboarding/views/onboarding_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var d = Duration(seconds: 5);
    Future.delayed(d).then((value) => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OnboardingScreen()))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          // color: AppColors.OnboardingColor,
          gradient: RadialGradient(
            colors: [AppColors.gradient,AppColors.gradient2,],
            radius: 0.8,

          )),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            SvgPicture.asset(
              AppIcons.svgLogo,
              color: AppColors.smokeWhite,
              height: 100,
              width: 100,
              alignment: Alignment.topCenter,
            ),
            const SizedBox(
              height: 16,
            ),
            SvgPicture.asset(
              AppIcons.svgAppName,
              color: AppColors.smokeWhite,
              height: 50,
              width: 50,
              alignment: Alignment.topCenter,
            ),
          ],
        ),
      ),
    ));
  }
}
