import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/local/dao/cache_user_dao.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/main.dart';
import 'package:creative_movers/screens/main/profile/widgets/options_item_widget.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  // final picker = ImagePicker();

  // _onImageSelected(dynamic pickedFile) async {
  //   File imageFile = File(pickedFile.path);

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => BlocProvider<ProfileEditCubit>(
  //         create: (context) => di.injector<ProfileEditCubit>(),
  //         child: ProfilePhotoEdit(
  //           imageFile: imageFile,
  //         ),
  //       ),
  //     ),
  //   );
// }

// _onRemovePhoto() async {
//   return BlocProvider<ProfileEditCubit>(
//     create: (context) => di.injector<ProfileEditCubit>(),
//     child: UpdatePhoneNumberPopup(),
//   );
// }
  final _cacheCubit = injector.get<CacheCubit>();
  final _profileBloc = ProfileBloc(injector.get());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String gender = 'Male';

    return Scaffold(
        body: BlocBuilder<CacheCubit, CacheState>(
      bloc: _cacheCubit,
      builder: (context, state) {
        if (state is CachedUserDataFetched) {
          var user = state.cachedUser;
          String? photo = user.coverPhotoPath;
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * .30,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: size.height * .41,
                        foregroundDecoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                        decoration: BoxDecoration(
                            image: photo == null || photo.isEmpty
                                ? DecorationImage(
                                    image: AssetImage(
                                        gender.toLowerCase() == 'female'
                                            ? 'assets/pngs/avatar_8.png'
                                            : 'assets/pngs/avatar_7.png'),
                                    fit: BoxFit.cover)
                                : DecorationImage(
                                    image: NetworkImage(photo),
                                    fit: BoxFit.cover),
                            gradient: const LinearGradient(colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor
                            ])),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: CircleImage(
                                url: user.profilePhotoPath,
                                withBaseUrl: false,
                                radius: 60,
                                borderWidth: 4,
                              ),
                            ),
                            BlocListener<ProfileBloc, ProfileState>(
                              bloc: _profileBloc,
                              listener: (context, state) {
                                if (state is ProfileLoading) {
                                  AppUtils.showAnimatedProgressDialog(context,
                                      title: "Updating image, please wait...");
                                }
                                if (state is ProfilePhotoUpdatedState) {
                                  Navigator.of(context).pop();
                                  AppUtils.showCustomToast(
                                      "Image has been updated successfully");
                                  _updateProfile(
                                      state.photo, state.isProfilePhoto);
                                }
                                if (state is ProfileErrorState) {
                                  Navigator.of(context).pop();
                                  AppUtils.showCustomToast(state.error);
                                }
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.6)),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      _showImageSelectionDialog(context, true);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        width: size.width,
                        child: Container(
                          height: size.height * .12,
                          // width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * .10),
                          padding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.03),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  user.fullname,
                                  style: const TextStyle(
                                      color: Color(0xFF363636),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Flexible(
                                child: Text(
                                  'MEMBER SINCE',
                                  style: TextStyle(
                                      color: Color(0xFFBDBDBD),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '10/04/2022',
                                  style: TextStyle(
                                      color: Color(0xFF363636).withOpacity(.6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * .06,
                        left: 15,
                        right: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 5, 1, 5),
                                decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white.withOpacity(.7),
                                ),
                              ),
                            ),

                            //update photo

                            GestureDetector(
                              onTap: () {
                                _showImageSelectionDialog(context, false);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 8, 10),
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/pngs/ic_profile_edit_photo.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                //info
                const SizedBox(height: 40),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .04),
                  child: Column(
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     // showDialog(
                      //     //   context: context,
                      //     //   builder: (context) {
                      //     //     return BlocProvider<ProfileEditCubit>(
                      //     //       create: (context) =>
                      //     //           di.injector<ProfileEditCubit>(),
                      //     //       child: UpdateDataPopup(),
                      //     //     );
                      //     //   },
                      //     // );
                      //   },
                      //   child: ProfileEditInfoWidget(
                      //     weight: profile.weight,
                      //     height: profile.height,
                      //     bloodType: profile.bloodtype,
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // OptionsItemWidget(
                          //   title: 'Calculate your BMI',
                          //   subtitle: 'Your Body Mass Index is a '
                          //       'measure of body fat',
                          //   onPressed: () async {
                          //     // Navigator.pushNamed(
                          //     //     context, Routes.calculateBmiScreen);
                          //   },
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              'EDIT PROFILE',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          OptionsItemWidget(
                            title: 'Phone',
                            subtitle: user.phone!,
                            onPressed: () async {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return BlocProvider<ProfileEditCubit>(
                              //       create: (context) =>
                              //           di.injector<ProfileEditCubit>(),
                              //       child: UpdatePhoneNumberPopup(),
                              //     );
                              //   },
                              // );
                            },
                          ),
                          OptionsItemWidget(
                            title: 'Email',
                            subtitle: user.email!,
                            // showAlertIcon: !profile.emailVerified,
                            // subtitleColor:
                            //     !profile.emailVerified ? Colors.red : null,
                            onPressed: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return BlocProvider<ProfileEditCubit>(
                              //       create: (context) =>
                              //           di.injector<ProfileEditCubit>(),
                              //       child: UpdateEmailPopup(),
                              //     );
                              //   },
                              // );
                            },
                          ),
                          const OptionsItemWidget(
                            title: 'Gender',
                            subtitle: "Male",
                            // onPressed: () {
                            //   showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return BlocProvider<ProfileEditCubit>(
                            //         create: (context) =>
                            //             di.injector<ProfileEditCubit>(),
                            //         child: UpdateGenderPopup(),
                            //       );
                            //     },
                            //   );
                            // },
                          ),
                          OptionsItemWidget(
                            title: 'Date of Birth',
                            subtitle: '10 April, 1992', //profile.dateOfBirth,
                            onPressed: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return BlocProvider<ProfileEditCubit>(
                              //       create: (context) =>
                              //           di.injector<ProfileEditCubit>(),
                              //       child: CalendarPopup(),
                              //     );
                              //   },
                              // );
                            },
                          ),
                          OptionsItemWidget(
                            title: 'Ethnicity',
                            subtitle: 'African',
                            onPressed: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return BlocProvider<ProfileEditCubit>(
                              //       create: (context) =>
                              //           di.injector<ProfileEditCubit>(),
                              //       child: UpdateEthnicity(),
                              //     );
                              //   },
                              // );
                            },
                          ),
                          OptionsItemWidget(
                            title: 'Location',
                            subtitle: 'Nigeria',
                            onPressed: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return BlocProvider<ProfileEditCubit>(
                              //       create: (context) =>
                              //           di.injector<ProfileEditCubit>(),
                              //       child: UpdateLocationPopup(),
                              //     );
                              //   },
                              // );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    ));
    // });
  }

  Future<void> _updateProfile(String photo, bool isProfilePhoto) async {
    try {
      var list = await injector.get<CacheCachedUserDao>().getAllCache();
      if (isProfilePhoto) {
        injector
            .get<CacheCubit>()
            .updateCachedUserData(list.first.copyWith(profilePhotoPath: photo));
      } else {
        var user = list.first.copyWith(coverPhotoPath: photo);
        log("USER DATA: ${user.toMap()}");

        // log("COVER RETURNED WITH: $photo");
        injector.get<CacheCubit>().updateCachedUserData(user);
      }

      injector.get<ProfileBloc>().add(const FetchUserProfileEvent());
    } catch (e) {
      print(e);
    }
  }

  void _showImageSelectionDialog(
    BuildContext context,
    bool isProfilePhoto,
  ) {
    AppUtils.selectImage(mainNavKey.currentContext!, (images) {
      if (images.isEmpty) return;
      _profileBloc.add(UpdateProfilePhotoEvent(images.first,
          isProfilePhoto: isProfilePhoto));
    }, hasViewAction: true, onViewAction: () {});
  }
}
