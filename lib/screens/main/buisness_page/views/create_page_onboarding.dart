import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/create_page_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePageOnboarding extends StatefulWidget {
  const CreatePageOnboarding({Key? key}) : super(key: key);

  @override
  _CreatePageOnboardingState createState() => _CreatePageOnboardingState();
}

class _CreatePageOnboardingState extends State<CreatePageOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: const [
                    CircleAvatar(
                      backgroundColor: AppColors.lightGrey,
                      radius: 20,
                      child: Center(
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Create Page',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                    child: Container(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 0,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.svgIdea,
                            color: AppColors.primaryColor,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Expanded(
                            child: Text(
                              'A page is a space where Movers can publicly connect '
                              'with your ideas/ personal brand or organization ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.photo_camera_rounded,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                                'You can do things like showcase products and services,'
                                ' collect donations and create ads ',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.svgConnects,
                            color: AppColors.primaryColor,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Expanded(
                              child: Text(
                            'Millions of Movers discover and connect with Pages every day',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                      SvgPicture.asset(
                        AppIcons.svgCreate,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),

                    ],
                  ),
                )),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),

                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),

                        onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePageScreen(),));
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                  const Text('By Clicking Get Started You Agree To  The',style: TextStyle(fontWeight: FontWeight.w600),),
                  const SizedBox(height: 10,),
                  const Text('Creative Movers Terms',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 25,
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
