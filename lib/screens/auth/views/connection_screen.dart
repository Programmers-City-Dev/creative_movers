import 'dart:developer';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/data/remote/model/account_type_response.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/payment/views/payment_screen.dart';
import 'package:creative_movers/screens/auth/widgets/contact_item.dart';
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
          // TODO: implement listener
          //
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16)),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentScreen()),
                                    (route) => false);
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'Skip',
                                    style:
                                        TextStyle(color: AppColors.textColor),
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
                                  backgroundColor: AppColors.primaryColor,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16)),
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
                      if (myConnects.contains(widget.connections[index])) {
                        myConnects.remove(widget.connections[index]);
                        log(
                          'MY CONNECTS: $myConnects',
                        );
                      } else {
                        myConnects.add(widget.connections[index]);
                        log(
                          'MY CONNECTS: ${myConnects.length}',
                        );
                      }
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
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const PaymentScreen(
                    isFirstTime: true,
                  )),
          (route) => false);
    }
  }
}
