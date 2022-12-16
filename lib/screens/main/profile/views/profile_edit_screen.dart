import 'dart:developer';
import 'dart:ui';

import 'package:creative_movers/app.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/local/dao/cache_user_dao.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/profile/views/edit_email_dialog.dart';
import 'package:creative_movers/screens/main/profile/views/edit_fullname_dialog.dart';
import 'package:creative_movers/screens/main/profile/views/edit_gender_dialog.dart';
import 'package:creative_movers/screens/main/profile/views/edit_phone_number_dialog.dart';
import 'package:creative_movers/screens/main/profile/widgets/options_item_widget.dart';
import 'package:creative_movers/screens/main/profile/widgets/update_ethnicity.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/image_previewer.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../data/local/model/cached_user.dart';
import 'edit_location_dialog.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

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
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, DateTime? dateOfBirth) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        confirmText: 'Ok',
        helpText: 'DATE OF BIRTH',
        initialDate: dateOfBirth ?? selectedDate,
        firstDate: DateTime(1, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _profileBloc.add(UpdateProfileEvent(dateOfBirth: selectedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: BlocBuilder<CacheCubit, CacheState>(
      bloc: _cacheCubit,
      builder: (context, state) {
        if (state is CachedUserDataFetched) {
          var user = state.cachedUser;
          String? photo = user.coverPhotoPath;
          String gender = user.gender ?? "Male";

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
                        foregroundDecoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.5)),
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
                                      color: AppColors.black.withOpacity(0.6)),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.white,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 12),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(.03),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 10),
                                )
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          user.fullname,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Color(0xFF363636),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2, sigmaY: 2),
                                            child: EditFullnameDialog(
                                              onSuccess: (user) async {
                                                Navigator.pop(context);
                                                _updateUserProfile(
                                                    user.toMap());
                                              },
                                              firstName: user.firstname!,
                                              lastName: user.lastname!,
                                            ),
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        // clipBehavior: Clip.antiAliasWithSaveLayer,
                                      );
                                    },
                                    child: const Icon(Icons.edit_outlined,
                                        color: AppColors.black, size: 20),
                                  )
                                ],
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
                                      color: const Color(0xFF363636)
                                          .withOpacity(.6),
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
                                    color: AppColors.black,
                                    shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.white.withOpacity(.7),
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
                                  color: AppColors.black,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              'BASIC INFO',
                              style: TextStyle(
                                  color: AppColors.black.withOpacity(.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          OptionsItemWidget(
                            title: 'Phone',
                            subtitle: user.phone!,
                            onPressed: () async {
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                    child: EditPhoneNumberDialog(
                                      phoneNumber: user.phone!,
                                      onSuccess: (user) {
                                        _updateUserProfile(user.toMap());

                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                // clipBehavior: Clip.antiAliasWithSaveLayer,
                              );

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
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                    child: EditEmailDialog(
                                        onSuccess: (updatedUser) {
                                          _updateUserProfile(
                                              updatedUser.toMap());
                                          setState(() {
                                            user = user.copyWith(
                                                email: updatedUser.email);
                                            log(user.email!);
                                          });
                                          Navigator.pop(context);
                                        },
                                        initialEmail: user.email),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                // clipBehavior: Clip.antiAliasWithSaveLayer,
                              );
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
                          OptionsItemWidget(
                            title: 'Gender',
                            subtitle: user.gender ?? "None",
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2, sigmaY: 2),
                                      child: EditGenderDialog(
                                        onSuccess: (user) {
                                          _updateUserProfile(user.toMap());
                                          Navigator.pop(context);
                                        },
                                      ));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                // clipBehavior: Clip.antiAliasWithSaveLayer,
                              );
                            },
                          ),
                          BlocListener<ProfileBloc, ProfileState>(
                            bloc: _profileBloc,
                            listener: (context, state) {
                              if (state is ProfileUpdateLoading) {
                                AppUtils.showAnimatedProgressDialog(context,
                                    title: "Updating, please wait...");
                              }
                              if (state is ProfileUpdateLoadedState) {
                                // setState(() {
                                //
                                // });
                                _updateUserProfile(
                                    state.updateProfileResponse.user.toMap());

                                Navigator.of(context).pop();
                                // AppUtils.cancelAllShowingToasts();
                                AppUtils.showCustomToast(
                                    "Date Of Birth has been updated successfully");
                                // _updateProfile(
                                //     state.photo, state.isProfilePhoto);
                              }
                              if (state is ProfileUpdateErrorState) {
                                Navigator.of(context).pop();
                                AppUtils.showCustomToast(state.error);
                              }
                            },
                            child: OptionsItemWidget(
                              title: 'Date of Birth',
                              subtitle: user.dateOfBirth != null
                                  ? DateFormat("MMMM dd, yyyy")
                                      .format(user.dateOfBirth!)
                                  : 'None',
                              //profile.dateOfBirth,
                              onPressed: () {
                                _selectDate(context, user.dateOfBirth);
                              },
                            ),
                          ),
                          OptionsItemWidget(
                            title: 'Ethnicity',
                            subtitle: user.ethnicity ?? 'None',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                    child: UpdateEthnicity(
                                      defaultValue: user.ethnicity ?? '',
                                      onSuccess: (updatedUser) {
                                        _updateUserProfile(updatedUser.toMap());

                                        setState(() {
                                          user = user.copyWith(
                                              country: updatedUser.country);
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                              // showMaterialModalBottomSheet(
                              //   context: context,
                              //   builder: (context) {
                              //     return BackdropFilter(
                              //       filter:
                              //           ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              //       child: EditEthnicityDialog(
                              //         onSuccess: (updatedUser) {
                              //           _updateUserProfile(updatedUser.toMap());

                              //           setState(() {
                              //             user = user.copyWith(
                              //                 country: updatedUser.country);
                              //           });
                              //           Navigator.pop(context);
                              //         },
                              //         initialEthnicity: user.country,
                              //       ),
                              //     );
                              //   },
                              //   shape: const RoundedRectangleBorder(),
                              //   // clipBehavior: Clip.antiAliasWithSaveLayer,
                              // );

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
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'LOCATION',
                                  style: TextStyle(
                                      color: AppColors.black.withOpacity(.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: EditLocationDialog(
                                            onSuccess: (updatedUser) {
                                              _updateUserProfile(
                                                  updatedUser.toMap());

                                              setState(() {
                                                user = user.copyWith(
                                                    country:
                                                        updatedUser.country);
                                              });
                                              Navigator.pop(context);
                                            },
                                            initialCountry: user.country,
                                          ),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                                    );
                                  },
                                  child: const Icon(Icons.edit_outlined,
                                      color: AppColors.black, size: 20),
                                )
                              ],
                            ),
                          ),
                          OptionsItemWidget(
                            title: 'Country',
                            subtitle: user.country ?? 'None',
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                    child: EditLocationDialog(
                                      onSuccess: (updatedUser) {
                                        _updateUserProfile(updatedUser.toMap());

                                        setState(() {
                                          user = user.copyWith(
                                              country: updatedUser.country);
                                        });
                                        Navigator.pop(context);
                                      },
                                      initialCountry: user.country,
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                // clipBehavior: Clip.antiAliasWithSaveLayer,
                              );

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
                          OptionsItemWidget(
                            title: 'State',
                            subtitle: user.state ?? "none",
                            // onPressed: () {
                            //   showMaterialModalBottomSheet(
                            //     context: context,
                            //     builder: (context) {
                            //       return BackdropFilter(
                            //         filter:
                            //             ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            //         child: EditStateDialog(
                            //           onSuccess: (user) {
                            //             _updateUserProfile(user.toMap());

                            //             Navigator.pop(context);
                            //           },
                            //         ),
                            //       );
                            //     },
                            //     shape: const RoundedRectangleBorder(),
                            //     // clipBehavior: Clip.antiAliasWithSaveLayer,
                            //   );
                            // },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
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
        log("USER UPDATE 2: ${list.first.toMap()}");
      } else {
        var user = list.first.copyWith(coverPhotoPath: photo);
        log("USER UPDATE 1: ${user.toMap()}");

        // log("COVER RETURNED WITH: $photo");
        injector.get<CacheCubit>().updateCachedUserData(user);
      }

      injector.get<ProfileBloc>().add(const FetchUserProfileEvent());
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateUserProfile(Map<String, dynamic> userData) async {
    try {
      injector
          .get<CacheCubit>()
          .updateCachedUserData(CachedUser.fromMap(userData));
      injector.get<ProfileBloc>().add(const FetchUserProfileEvent());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showImageSelectionDialog(
    BuildContext context,
    bool isProfilePhoto,
  ) {
    AppUtils.selectFiles(
        mainNavKey.currentContext!,
        (images) {
          if (images.isEmpty) return;
          _profileBloc.add(UpdateProfilePhotoEvent(images.first,
              isProfilePhoto: isProfilePhoto));
        },
        hasViewAction: false,
        onViewAction: () {
          showMaterialModalBottomSheet(
              context: mainNavKey.currentContext!,
              isDismissible: false,
              enableDrag: false,
              expand: false,
              builder: (context) =>
                  const ImagePreviewer(heroTag: "profile_photo", imageUrl: ''));
        });
  }
}
