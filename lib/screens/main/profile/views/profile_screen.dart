import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/local/dao/cache_user_dao.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileBloc = injector.get<ProfileBloc>();

  @override
  void initState() {
    super.initState();
    _profileBloc.add(const FetchUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            User user = state.user;
            injector
                .get<CacheCubit>()
                .updateCachedUserData(user.toCachedUser());
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 340,
                    child: Stack(
                      // clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 250,
                            color: AppColors.primaryColor,
                            // decoration: BoxDecoration(image: ()),
                            child: CachedNetworkImage(
                              imageUrl: user.coverPhotoPath!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Image.asset(
                                'assets/pngs/creative_splash.PNG',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 20,
                            right: 0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CircleAvatar(
                                        radius: 70,
                                        backgroundColor: AppColors.lightBlue,
                                        child: CircleImage(
                                          url: user.profilePhotoPath,
                                          radius: 75,
                                          borderWidth: 5,
                                          withBaseUrl: false,
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Positioned(
                                          right: -5,
                                          bottom: 7,
                                          child: GestureDetector(
                                            onTap: () {
                                              print("Testing");
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoActionSheet(
                                                      title: const Text(
                                                        'Change Profile Picture',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8F8F8F),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      actions: [
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            // Navigator.of(context).pop();

                                                            // final pickedFile =
                                                            //     await picker.getImage(
                                                            //         source: ImageSource.camera,
                                                            //         maxHeight: 500,
                                                            //         maxWidth: 500,
                                                            //         imageQuality: 50);

                                                            // if (pickedFile != null) {
                                                            //   _onImageSelected(pickedFile);
                                                            // }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: const [
                                                                Text(
                                                                  'Take Photo',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF181818),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Color(
                                                                        0xFF007AFF))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            // final pickedFile =
                                                            //     await picker.getImage(
                                                            //         source: ImageSource.gallery,
                                                            //         maxHeight: 500,
                                                            //         maxWidth: 500,
                                                            //         imageQuality: 50);

                                                            // if (pickedFile != null) {
                                                            //   if (pickedFile != null) {
                                                            //     _onImageSelected(pickedFile);
                                                            //   }
                                                            // }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: const [
                                                                Text(
                                                                  'Photo Library',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF181818),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .content_copy,
                                                                    color: Color(
                                                                        0xFF007AFF))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // if (profile.photo != null &&
                                                        //     profile.photo != '')
                                                        //   BlocProvider<ProfileEditCubit>(
                                                        //     create: (context) =>
                                                        //         di.injector<ProfileEditCubit>(),
                                                        //     child: BlocConsumer<ProfileEditCubit,
                                                        //         ProfileEditState>(
                                                        //       listener: (context, state) {
                                                        //         if (state is ProfileEditSuccess) {
                                                        //           profileBloc.add(
                                                        //             ProfileLoad(
                                                        //               profile: state.profile,
                                                        //             ),
                                                        //           );
                                                        //           Navigator.of(context).pop();
                                                        //         } else if (state
                                                        //             is ProfileEditError) {
                                                        //           print(state.errorModel);
                                                        //           DROFlushBar.error(
                                                        //             context: context,
                                                        //             message: state
                                                        //                 .errorModel.errorMessage,
                                                        //           );
                                                        //         }
                                                        //       },
                                                        //       builder: (context, state) =>
                                                        //           CupertinoActionSheetAction(
                                                        //         onPressed: () async {
                                                        //           Navigator.of(context).pop();

                                                        //           //remove image
                                                        //           // ProfileEditCubit cubit =
                                                        //           //     di.injector<
                                                        //           //         ProfileEditCubit>();

                                                        //           // cubit.removePhoto(
                                                        //           //   profile: profile,
                                                        //           // );
                                                        //         },
                                                        //         child: Padding(
                                                        //           padding:
                                                        //               const EdgeInsets.symmetric(
                                                        //                   horizontal: 12.0),
                                                        //           child: Row(
                                                        //             mainAxisAlignment:
                                                        //                 MainAxisAlignment
                                                        //                     .spaceBetween,
                                                        //             children: const [
                                                        //               Text(
                                                        //                 'Remove Photo',
                                                        //                 style: TextStyle(
                                                        //                   color: Colors.red,
                                                        //                   fontSize: 16,
                                                        //                   fontWeight:
                                                        //                       FontWeight.w400,
                                                        //                 ),
                                                        //               ),
                                                        //               Icon(Icons.delete,
                                                        //                   color: Colors.red)
                                                        //             ],
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //   )
                                                      ],
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF007AFF),
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: const CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  AppColors.lightBlue,
                                              child: CircleAvatar(
                                                radius: 22,
                                                child: Icon(
                                                  Icons.photo_camera_rounded,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(18),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 32,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                color: AppColors.primaryColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                user.role!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.biodata!,
                          style: const TextStyle(
                              fontSize: 16, color: AppColors.textColor),
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
                                Navigator.of(context)
                                    .pushNamed(profileEditPath);
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
                        const UserMetricsOverview(),
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
                                  itemBuilder: (context, index) =>
                                      const Padding(
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
                                        EdgeInsets.symmetric(vertical: 10)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
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
                        SizedBox(
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
            );
          }
          if (state is ProfileErrorState) {
            return AppPromptWidget(
              title: "Unable to load profile",
              message: state.error,
              isSvgResource: true,
              onTap: () => _profileBloc.add(const FetchUserProfileEvent()),
            );
          }
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class UserMetricsOverview extends StatelessWidget {
  const UserMetricsOverview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const SizedBox(
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
