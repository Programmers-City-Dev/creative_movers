import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/onboarding/views/onboarding_item.dart';
import 'package:creative_movers/screens/onboarding/widgets/dot_indicator.dart';
import 'package:creative_movers/screens/auth/views/signup_screen.dart';
import 'package:creative_movers/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
              header: 'Creative Movers',
              text: Text.rich(
                const TextSpan(style: TextStyle(fontSize: 13), children: [
                  TextSpan(
                    text: 'The only true ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  TextSpan(
                    text: 'Buisness Networking',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(
                    text: ' Social Application',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  )
                ]),
                textAlign: TextAlign.center,
                style: DefaultTextStyle.of(context).style,
              ), img: AppIcons.imgSlide1,
            ),
            OnboardingItem(
              header: ' The Creatives',
              text: Text.rich(
                const TextSpan(style: TextStyle(fontSize: 13), children: [
                  TextSpan(
                    text: 'Creatives are Entreprenuers  ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(
                    text: 'that have an idea, product ,invention etc looking for help to take it into the market',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                ]),
                textAlign: TextAlign.center,
                style: DefaultTextStyle.of(context).style,
              ), img: AppIcons.imgSlide2,
            ),
            OnboardingItem(
              header: 'The Movers',
              text: Text.rich(
                const TextSpan(style: TextStyle(fontSize: 13), children: [
                  TextSpan(
                    text: 'Movers ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(
                    text: 'are individuals who help entreprenuers take their ideas to the ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  TextSpan(
                    text: ' next level',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ]),
                textAlign: TextAlign.center,
                style: DefaultTextStyle.of(context).style,
              ), img: AppIcons.imgSlide3,
            ),
            OnboardingItem(
              header: 'Which are You ?',
              text: Text.rich(
                const TextSpan(style: TextStyle(fontSize: 13), children: [
                  TextSpan(
                    text: 'You can choose to be a  ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  TextSpan(
                    text: 'creative',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(
                    text: ' or a',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  TextSpan(
                    text: ' mover',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(
                    text: ' it is up to you and your personnal interest',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                ]),
                textAlign: TextAlign.center,
                style: DefaultTextStyle.of(context).style,
              ), img: AppIcons.imgSlide4,
            )
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
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppIcons.icSplashLogo))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
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
                    child: Visibility(
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
