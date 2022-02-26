import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/screens/main/profile/widgets/options_item_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final profileBloc = di.injector<ProfileBloc>();

    // ProfileModel profile =
    //     (context.watch<ProfileBloc>().state as ProfileLoaded).profile;

    String? photo;
    String gender = 'Male';

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
            create: (context) => injector.get<ProfileBloc>()),
      ],
      // create: (context) => di.injector<ProfileEditCubit>(),
      child: Scaffold(
          body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: size.height * .49,
              child: Stack(
                children: [
                  Container(
                    height: size.height * .41,
                    decoration: BoxDecoration(
                        image: photo == null || photo.isEmpty
                            ? DecorationImage(
                                image: AssetImage(
                                    gender.toLowerCase() == 'female'
                                        ? 'assets/pngs/avatar_8.png'
                                        : 'assets/pngs/avatar_7.png'),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image: NetworkImage(photo), fit: BoxFit.cover),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        gradient: const LinearGradient(colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor
                        ])),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * .12,
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: size.width * .10),
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
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Anyanwu Nzubechi',
                              style: TextStyle(
                                  color: Color(0xFF363636),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Flexible(
                            child: Text(
                              'JOINED CREATIVE MOVERS',
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
                                color: Colors.black45, shape: BoxShape.circle),
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
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return CupertinoActionSheet(
                                    title: const Text(
                                      'Change Profile Picture',
                                      style: TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Take Photo',
                                                style: TextStyle(
                                                  color: Color(0xFF181818),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Icon(Icons.camera_alt,
                                                  color: Color(0xFF007AFF))
                                            ],
                                          ),
                                        ),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          Navigator.of(context).pop();

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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Photo Library',
                                                style: TextStyle(
                                                  color: Color(0xFF181818),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Icon(Icons.content_copy,
                                                  color: Color(0xFF007AFF))
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
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Color(0xFF007AFF),
                                            fontSize: 18),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.mode_edit_outlined,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //info
            const SizedBox(height: 20),

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
                  SizedBox(height: 20),
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
                        subtitle: '09035980061',
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
                        subtitle: 'zubitex40@gmail.com',
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
                      // BlocBuilder<AddressBloc, AddressState>(
                      //   builder: (context, state) {
                      //     return ProfileOptionsItem(
                      //       title: 'Addresses',
                      //       subtitle: (state is AddressLoading)
                      //           // ignore: lines_longer_than_80_chars
                      //           // sets dots placeholder when address is loading
                      //           ? '...'
                      //           : (state is NoAddress)
                      //               // ignore: lines_longer_than_80_chars
                      //               // changes to No Address when address is empty
                      //               ? 'No Address'
                      //               : (state is AddressesAllFetched)
                      //                   // ignore: lines_longer_than_80_chars
                      //                   // specifies Address list length when address is retrieved
                      //                   ? '${state.addresses.length} Address${state.addresses.length > 1 ? 's' : ''} saved'
                      //                   : '...',
                      //       onPressed: () {
                      //         showMaterialModalBottomSheet(
                      //           barrierColor: Colors.black26,
                      //           context: context,
                      //           isDismissible: false,
                      //           builder: (_) {
                      //             return BlocProvider.value(
                      //               value: context.read<AddressBloc>(),
                      //               child: ManageAddressBottomSheet(
                      //                 patientId: profile.id,
                      //               ),
                      //             );
                      //           },
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      // //TODO: ADD REAL ZIP CODE TO PROFILE
                      // ProfileOptionsItem(
                      //   title: 'Zip Code',
                      //   subtitle: '99501',
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return BlocProvider<ProfileEditCubit>(
                      //           create: (context) =>
                      //               di.injector<ProfileEditCubit>(),
                      //           child: UpdateZipCodePopup(),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      // ProfileOptionsItem(
                      //   title: 'Timezone',
                      //   subtitle:
                      //       // ignore: lines_longer_than_80_chars
                      //       '${(context.read<ProfileBloc>().state as ProfileLoaded).profile.timezone}',
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return BlocProvider<ProfileEditCubit>(
                      //           create: (context) =>
                      //               di.injector<ProfileEditCubit>(),
                      //           child: UpdateTimezonePopup(),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      )),
    );
    // });
  }
}
