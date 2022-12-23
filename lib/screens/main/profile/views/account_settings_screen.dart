import 'package:creative_movers/app.dart';
import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/image_previewer.dart';
import 'package:creative_movers/screens/widget/widget_network_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _paymentBloc = PaymentBloc(injector.get());

  @override
  void initState() {
    injector.get<CacheCubit>().fetchCachedUserData();
    _paymentBloc.add(const GetSubscriptionInfoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<CacheCubit, CacheState>(
            bloc: injector.get<CacheCubit>(),
            builder: (context, state) {
              if (state is CachedUserDataFetched) {
                var cachedUser = state.cachedUser;
                // log('PHOTO:${cachedUser.profilePhotoPath}');
                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          height: 250,
                          // color: AppColors.primaryColor,
                          // decoration: BoxDecoration(image: ()),
                          child: Hero(
                            tag: "cover_photo",
                            child: GestureDetector(
                              onTap: cachedUser.coverPhotoPath != null
                                  ? () => showDialog(
                                        context: mainNavKey.currentContext!,
                                        // isDismissible: false,
                                        // enableDrag: false,
                                        barrierDismissible: true,
                                        builder: (context) => ImagePreviewer(
                                          imageUrl: cachedUser.coverPhotoPath!,
                                          heroTag: "cover_photo",
                                          tightMode: true,
                                        ),
                                      )
                                  : null,
                              child: WidgetNetworkImage(
                                image: cachedUser.coverPhotoPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          left: 0,
                          right: 0,
                          child: Center(
                              child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: cachedUser.profilePhotoPath != null
                                    ? () => showMaterialModalBottomSheet(
                                        context: mainNavKey.currentContext!,
                                        isDismissible: false,
                                        enableDrag: false,
                                        expand: false,
                                        builder: (context) => ImagePreviewer(
                                            heroTag: "profile_photo",
                                            imageUrl:
                                                cachedUser.profilePhotoPath!))
                                    : null,
                                child: CircleImage(
                                  url: cachedUser.profilePhotoPath,
                                  withBaseUrl: false,
                                  radius: 70,
                                  borderWidth: 5,
                                ),
                              ),
                              // const Positioned(
                              //   right: -5,
                              //   bottom: 7,
                              //   child: CircleAvatar(
                              //     radius: 25,
                              //     backgroundColor: AppColors.lightBlue,
                              //     child: CircleAvatar(
                              //       radius: 22,
                              //       child: Icon(
                              //         Icons.photo_camera_rounded,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Text(
                      cachedUser.fullname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          cachedUser.email!,
                          style: const TextStyle(),
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
                              Navigator.of(context).pushNamed(profilePath);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(Icons.person,
                                            size: 25,
                                            color: AppColors.textColor),
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
                                    const Icon(Icons.chevron_right_rounded,
                                        size: 30, color: AppColors.textColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 16, horizontal: 8.0),
                          //     child: Center(
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: const [
                          //               Icon(Icons.notifications,
                          //                   size: 25,
                          //                   color: AppColors.textColor),
                          //               SizedBox(
                          //                 width: 16,
                          //               ),
                          //               Text(
                          //                 'Notification',
                          //                 style: TextStyle(
                          //                     fontSize: 16,
                          //                     fontWeight: FontWeight.w600,
                          //                     color: AppColors.textColor),
                          //               ),
                          //             ],
                          //           ),
                          //           const Icon(Icons.chevron_right_rounded,
                          //               size: 30, color: AppColors.textColor),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(paymentHistoryPath);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(Icons.payment_outlined,
                                            size: 25,
                                            color: AppColors.textColor),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          'Payment History',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColor),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right_rounded,
                                        size: 30, color: AppColors.textColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(subscriptionPath);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(Icons.auto_fix_high,
                                            size: 25,
                                            color: AppColors.textColor),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          'My SubScription',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        BlocBuilder<PaymentBloc, PaymentState>(
                                            bloc: _paymentBloc,
                                            // ..add(
                                            //     const GetSubscriptionInfoEvent()),
                                            builder: (context, state) {
                                              if (state
                                                  is SubscriptionLoadedState) {
                                                var subscription = state
                                                    .data.user!.subscription;
                                                if (subscription != null) {
                                                  return Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        color: subscription
                                                                    .status ==
                                                                "active"
                                                            ? AppColors
                                                                .lightBlue
                                                            : subscription
                                                                        .status ==
                                                                    "trial"
                                                                ? Colors.orange
                                                                : AppColors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      subscription.status ==
                                                              "active"
                                                          ? 'Active'
                                                          : subscription
                                                                      .status ==
                                                                  "trial"
                                                              ? "Free Trial"
                                                              : 'Inactive',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: subscription
                                                                      .status ==
                                                                  "active"
                                                              ? AppColors
                                                                  .textColor
                                                              : AppColors
                                                                  .white),
                                                    ),
                                                  );
                                                }
                                              }
                                              if (state
                                                  is SubscriptionLoadingState) {
                                                return const Text('...');
                                              }
                                              return SizedBox.fromSize();
                                            }),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Icon(Icons.chevron_right_rounded,
                                            size: 30,
                                            color: AppColors.textColor),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     injector.get<PaymentBloc>().add(
                          //         MakePaymentWithIntentEvent(int.parse("7"),
                          //             "usd", "1", "account_activation"));
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 16, horizontal: 8.0),
                          //     child: Center(
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: const [
                          //               Icon(Icons.settings,
                          //                   size: 25,
                          //                   color: AppColors.textColor),
                          //               SizedBox(
                          //                 width: 16,
                          //               ),
                          //               Text(
                          //                 'Setting',
                          //                 style: TextStyle(
                          //                     fontSize: 16,
                          //                     fontWeight: FontWeight.w600,
                          //                     color: AppColors.textColor),
                          //               ),
                          //             ],
                          //           ),
                          //           const Icon(Icons.chevron_right_rounded,
                          //               size: 30, color: AppColors.textColor),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(helpAndSupportPath);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(
                                          LineIcons.questionCircleAlt,
                                          color: AppColors.textColor,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          'Help and Support',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColor),
                                        )
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

                          InkWell(
                            onTap: () {
                              AppUtils.showShowConfirmDialog(
                                context,
                                message: 'Are you sure you want to logout?',
                                cancelButtonText: 'Cancel',
                                confirmButtonText: 'Logout',
                                onConfirmed: () {
                                  // Navigator.pop(context);
                                  _logout();
                                },
                                onCancel: () {
                                  Navigator.of(mainNavKey.currentState!.context)
                                      .pop();
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                );
              }
              return const SizedBox.shrink();
            }),
      ),
    );
  }

  void _logout() {
    injector.get<AuthBloc>().add(LogoutEvent());
    clearCache();
    mainNavKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void clearCache() {
    StorageHelper.remove(StorageKeys.token);
    StorageHelper.setBoolean(StorageKeys.stayLoggedIn, false);
    injector.get<CacheCubit>().clearCacheStorage();

    // StorageHelper.setBoolean(StorageKeys.stayLoggedIn, true);
  }
}
