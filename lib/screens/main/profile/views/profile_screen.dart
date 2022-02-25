import 'dart:developer';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/remote/model/logout_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/main/profile/views/profile_details.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: (context, state) {
            _listenToAuthState(context, state);
            // TODO: implement listener
          },
          child: Column(
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
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileDetails(),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(Icons.person,
                                    size: 25, color: AppColors.textColor),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                      fontSize: 16,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.notifications,
                                  size: 25, color: AppColors.textColor),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Notification',
                                style: TextStyle(
                                    fontSize: 16,
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.settings,
                                  size: 25, color: AppColors.textColor),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Transation History',
                                style: TextStyle(
                                    fontSize: 16,
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.auto_fix_high,
                                  size: 25, color: AppColors.textColor),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'My SubScriptions',
                                style: TextStyle(
                                    fontSize: 16,
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.settings,
                                  size: 25, color: AppColors.textColor),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Setting',
                                style: TextStyle(
                                    fontSize: 16,
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.contact_support,
                                  size: 25, color: AppColors.textColor),
                              const SizedBox(
                                width: 16,
                              ),
                              BlocListener<PaymentBloc, PaymentState>(
                                bloc: injector.get<PaymentBloc>(),
                                listener: (context, state) {
                                  if(state is PaymentProcessingState){
                                    AppUtils.showAnimatedProgressDialog(context, title: "Processing");
                                  }
                                  if(state is PaymentFailureState){
                                    Navigator.of(context).pop();
                                    AppUtils.showCustomToast(state.error);
                                  }
                                  if(state is PaymentIntentGottenState){
                                    Navigator.of(context).pop();
                                    injector.get<PaymentBloc>().add(MakePaymentEvent(state.intent['client_secret']));
                                  }

                                  if(state is PaymentConfirmedState){
                                    Navigator.of(context).pop();
                                    AppUtils.showCustomToast(state.message);
                                  }
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    injector.get<PaymentBloc>().add(const CreatePaymentIntentEvent(20, "USD"));
                                  },
                                  child: const Text(
                                    'Help and Support',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textColor),
                                  ),
                                ),
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

                    InkWell(
                      onTap: () {
                        AppUtils.showShowConfirmDialog(
                          context,
                          message: 'Are you sure you wan to logout ?',
                          cancelButtonText: 'Cancel',
                          confirmButtonText: 'Logout',
                          onConfirmed: () {
                            Navigator.pop(context);
                            _logout();
                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(
                                  Icons.logout_rounded,
                                  color: AppColors.textColor,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor),
                                ),
                              ],
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.only(right: 16),
                            //   child: Icon(Icons.chevron_right_rounded,
                            //       size: 30, color: AppColors.textColor),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listenToAuthState(BuildContext context, AuthState state) {
    if (state is LogoutLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }
    if (state is LogoutFaliureState) {
      Navigator.of(context).pop();
      CustomSnackBar.showError(context, message: state.error);
    }
    if (state is LogoutSuccessState) {
      clearCache(state.logoutResponse);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    }
  }

  void _logout() {
    _authBloc.add(LogoutEvent());
  }

  void clearCache(LogoutResponse response) {
    StorageHelper.remove(StorageKeys.token);
    StorageHelper.setBoolean(StorageKeys.stayLoggedIn, false);

    // StorageHelper.setBoolean(StorageKeys.stayLoggedIn, true);
  }
}
