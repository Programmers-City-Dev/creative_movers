import 'dart:developer';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/models/logout_response.dart';
import 'package:creative_movers/models/state.dart' as st;
import 'package:creative_movers/repository/remote/payment_repository.dart';
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
  AuthBloc _authBloc = AuthBloc();

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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileDetails(),
                        ));
                      },
                      child: Center(
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
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

                              GestureDetector(
                                onTap: () async {
                                  await makePayment();
                                  // await confirmPayment();
                                  // final paymentMethod = await Stripe.instance
                                  //     .createPaymentMethod(
                                  //         const PaymentMethodParams.card(setupFutureUsage: 'OffSession',
                                  //           billingDetails: BillingDetails(
                                  //             address: Address(
                                  //               city: "Owerri",
                                  //               country: "Nigeria",
                                  //               state: "Imo",
                                  //               postalCode: "4420043",
                                  //               line1: "+2449035980061",
                                  //                 line2: '+2347038283454'
                                  //             ),
                                  //             email: "zubitex40@gmail.com",
                                  //             name: "Anyanwu Nzubechi",
                                  //             phone: "+2349035980061"
                                  //           )
                                  //         ));
                                },
                                child: const Text(
                                  'Help and Support',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor),
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
                    const SizedBox(
                      height: 30,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
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

  Future<void> makePayment() async{
    try{
      Map<String, dynamic> paymentIntent = await _createPaymentIntent(20, "USD");
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        applePay: true,
        googlePay: true,
        style: ThemeMode.light,
         merchantCountryCode: "US",
        merchantDisplayName: "Creative Movers Pay",

      ));

      displayPaymentSheet(paymentIntent['client_secrete']);

    }catch(e){
      print("Payment error: $e");
    }
  }

  void displayPaymentSheet(paymentIntent) async{
    try{
      await Stripe.instance.presentPaymentSheet(parameters: paymentIntent);
    }catch(e){
      print("SHEET ERROR");
    }
  }

  _createPaymentIntent(int amount, String currency) async{
    try{
      Map<String, dynamic> body = {
        "amount": (amount * 100).toString(),
        "currency" : currency,
        "payment_method_types[]" : "card"
      };
      var res = await PaymentRepository(injector.get()).createPaymentIntent(body);
      if(res is st.SuccessState){
        log("PAYMENT CREATED: ${res.value}");
        return res.value;
      }else{
        log("ERROR OCCURRED");
        return {};
      }
    }catch(e){
      print("Intent error: $e");
      return {};
    }
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
        builder: (context) => LoginScreen(),
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
