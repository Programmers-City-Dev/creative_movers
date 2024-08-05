import 'dart:developer';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/data/remote/model/account_type_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/subscription_helper.dart';
import 'package:creative_movers/screens/auth/widgets/contact_item.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/main/payment/views/subscription_screen.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectionScreen extends StatefulWidget {
  final String? role;

  const ConnectionScreen(
      {Key? key, required this.connections, required this.role})
      : super(key: key);
  final List<Connect> connections;

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  bool isAdded = false;
  List<Connect> myConnects = [];
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {
          _listenToAccountTypeState(context, state);
          //
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'Add Connects',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Expanded(
                      //     child: SearchField(
                      //   hint: 'Search Contacts',
                      // )),
                    ],
                  ),
                  Text(
                    widget.role == 'creative'
                        ? 'We found some movers you might like to connect with'
                        : 'We found some creatives you might like to connect with',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.lightGrey,
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16)),
                            onPressed: () {
                              _goToNextScreen(context);
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'Skip',
                                  style: TextStyle(color: AppColors.textColor),
                                ),
                                Icon(
                                  Icons.skip_next_outlined,
                                  color: AppColors.textColor,
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.darkBlue,
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16)),
                            onPressed: () {
                              addConnections();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => const PaymentScreen(),
                              // ));
                            },
                            child: const Text(
                              'Add',
                              style: TextStyle(color: AppColors.white),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                thickness: 2,
              ),
            ),
            Expanded(
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.connections.length,
              itemBuilder: (context, index) => ContactItem(
                onTap: () {
                  setState(() {
                    _handleConnection(index);
                    // isAdded = !isAdded;
                  });
                },
                isAdded: myConnects.contains(widget.connections[index]),
                connect: widget.connections[index],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void addConnections() {
    _authBloc.add(AddConnectionsEvent(
      connection: myConnects,
    ));
  }

  void _listenToAccountTypeState(BuildContext context, AuthState state) {
    if (state is AddConnectionLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }

    if (state is AddConnectionFailureState) {
      Navigator.pop(context);
      CustomSnackBar.showError(context, message: state.error);
    }

    if (state is AddConnectionSuccesState) {
      _goToNextScreen(context);
    }
  }

  void _handleConnection(int index) {
    if (myConnects.contains(widget.connections[index])) {
      myConnects.remove(widget.connections[index]);
      log(
        'MY CONNECTS: $myConnects',
      );
    } else {

      if (myConnects.length >= 5 &&
          !SubscriptionHelper.hasActiveSubscription()) {
        CustomSnackBar.showMessage(context,
            message: 'You can only connect to 5 persons until you subscribe.');
      } else {
        myConnects.add(widget.connections[index]);
      }

      log(
        'MY CONNECTS: ${myConnects.length}',
      );
    }
  }

  void _goToNextScreen(BuildContext context) {
    var user = injector.get<CacheCubit>().cachedUser;

    // if (user?.accountType?.toLowerCase() != 'premium') {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
            builder: (context) => const SubscriptionScreen(
                  isFromSignup: true,
                )),).then((success) {
        if (success != null && success) {
          AppUtils.showCustomToast("Subscription was successful");
        }
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const HomeScreen(
                    showWelcomeDialog: true,
                  )),
        );
      });

  }
}
