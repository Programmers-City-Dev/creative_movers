import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    color: AppColors.primaryColor,
                  ),
                  Positioned(
                      bottom: -50,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                        children: const [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: AppColors.lightBlue,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
                              ),
                              radius: 60,
                            ),
                          ),
                          Positioned(
                            right: -5,
                            bottom: 7,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.lightBlue,
                              child: CircleAvatar(
                                radius: 22,
                                child: Icon(
                                  Icons.photo_camera_rounded,
                                ),
                              ),
                            ),
                          )
                        ],
                      )))
                ],
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            const Text(
              'Amander Berks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.near_me_rounded,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Carlifonia, Badwin park',
                  style: TextStyle(),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.person,
                                size: 30, color: AppColors.textColor),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Profile',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.chevron_right_rounded,
                              size: 30, color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.notifications,
                                size: 30, color: AppColors.textColor),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Notification',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.chevron_right_rounded,
                              size: 30, color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.settings,
                                size: 30, color: AppColors.textColor),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Transation History',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.chevron_right_rounded,
                              size: 30, color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.auto_fix_high,
                                size: 30, color: AppColors.textColor),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'My SubScriptions',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.chevron_right_rounded,
                              size: 30, color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.settings,
                                size: 30, color: AppColors.textColor),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Setting',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.chevron_right_rounded,
                              size: 30, color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.contact_support,
                                size: 30, color: AppColors.textColor),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Help and Support',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.chevron_right_rounded,
                              size: 30, color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
