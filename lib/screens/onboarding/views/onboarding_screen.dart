import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/onboarding/views/onboarding_item.dart';
import 'package:creative_movers/screens/onboarding/widgets/dot_indicator.dart';
import 'package:creative_movers/screens/auth/views/signup_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          controller: PageController(viewportFraction: 1),
          children: [
            OnboardingItem(
              header: AppLocalizations.of(context)!.intro1Title,
              text: Text(
                    AppLocalizations.of(context)!.intro1Text,
                textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ), img: AppIcons.imgSlide1,
            ),
            OnboardingItem(
              header: AppLocalizations.of(context)!.intro2Title,
              text: Text(
                AppLocalizations.of(context)!.intro2Text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ), img: AppIcons.imgSlide2,
            ),
            OnboardingItem(
              header: AppLocalizations.of(context)!.intro3Title,
              text: Text(
                AppLocalizations.of(context)!.intro3Text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ), img: AppIcons.imgSlide2,
            ),
            OnboardingItem(
              header: AppLocalizations.of(context)!.intro4Title,
              text: Text(
                AppLocalizations.of(context)!.intro4Text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ), img: AppIcons.imgSlide2,
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                visible: _currentIndex == 3,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: _currentIndex ==3?1.0:0.0,
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,

                    child:  SvgPicture.asset(AppIcons.svgSplashLogo,color: AppColors.primaryColor,),

                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 10,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: DotIndicator(
                          inActiveColor: Colors.grey,
                          active_color: Colors.white,
                          size: 10,
                          isActive: _currentIndex == index ? true : false,
                        ),
                      ),
                      shrinkWrap: true,
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Stack(
                      children: [
                        Visibility(
                            visible: _currentIndex != 3,
                            child: Container(height: 50,)),
                        Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _currentIndex == 3,
                        child: AnimatedOpacity(
                          opacity: _currentIndex ==3 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen(),));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('Get Started'),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward,color: AppColors.primaryColor,)
                                ],
                              )),
                          ),
                        ),
                      )],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
