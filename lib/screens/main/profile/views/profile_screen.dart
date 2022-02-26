import 'dart:developer';

import 'package:creative_movers/data/local/dao/cache_user_dao.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 250,
                    color: AppColors.primaryColor,
                    // decoration: BoxDecoration(image: ()),
                  ),
                  Positioned(
                    bottom: -85,
                    left: 20,
                    right: 0,
                    child: Hero(
                      tag: 'profile-image',
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: const [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: AppColors.lightBlue,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
                                ),
                                radius: 65,
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
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(18),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Creative',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "I am senior developer that focus on mobile apps and web development. "
                    "I am not only competent in delivering the effective deliverable,"
                    " but I...",
                    style: TextStyle(fontSize: 16, color: AppColors.textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'See More About Yourself',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () async {
                          var allCache = await injector
                              .get<CacheCachedUserDao>()
                              .getAllCache();
                          log('${allCache.first.toMap()}');
                        },
                        child: const Text('Edit Details'),
                        style: TextButton.styleFrom(
                            backgroundColor: AppColors.lightBlue),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            AppIcons.svgProjects,
                            color: AppColors.primaryColor,
                          ),
                          const Text(
                            "114k",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Projects",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 50,
                        width: 2,
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          SvgPicture.asset(
                            AppIcons.svgConnects,
                            color: AppColors.primaryColor,
                          ),
                          const Text(
                            "114k",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Connects",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 50,
                        width: 2,
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          SvgPicture.asset(
                            AppIcons.svgFollowing,
                            color: AppColors.primaryColor,
                          ),
                          const Text(
                            "114k",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Follwing",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'CONNECTS',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: 6,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                                ),
                                radius: 25,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('+350k'),
                          style: TextButton.styleFrom(
                              backgroundColor: AppColors.lightBlue,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'BUSINESS/INVESTMENT',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '+2 more',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        width: 110,
                        margin: EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                                ))),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1),
//         child: TextButton(
//           onPressed: () {},
//           child: SvgPicture.asset(
//             'assets/svgs/chats.svg',
//             color: AppColors.primaryColor,
//             width: 24,
//           ),
//           style: TextButton.styleFrom(
//               backgroundColor: Colors.white,
//               shape: StadiumBorder(),
//               padding: const EdgeInsets.symmetric(horizontal: 25)),
//         ),
//       ),
//     ),
//     Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         child: TextButton(
//           onPressed: () {},
//           child: Text("CONNECT",style: const TextStyle(color: Colors.white,fontSize: 10),),
//           style: TextButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               shape: StadiumBorder(),
//               padding: const EdgeInsets.symmetric(horizontal: 25)),
//         ),
//       ),
//     ),
//     Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1),
//         child: TextButton(
//           onPressed: () {},
//           child: Icon(Icons.more_horiz),
//           style: TextButton.styleFrom(
//               backgroundColor: Colors.white,
//               shape: StadiumBorder(),
//               padding: const EdgeInsets.symmetric(horizontal: 25)),
//         ),
//       ),
//     ),
//
//
//
//   ],
// )
