import 'dart:io';

import 'package:creative_movers/cubit/in_app_payment_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool? isFromSignup;

  const SubscriptionScreen({
    Key? key,
    this.isFromSignup = false,
  }) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<String> _subIds = [
    'com.creativemovers.m7',
  ];

  String? _selectedProductId;
  final InAppPaymentCubit _appPaymentCubit = InAppPaymentCubit(injector.get());

  @override
  void initState() {
    super.initState();
    _selectedProductId = _subIds.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
        leading: widget.isFromSignup!
            ? null
            : IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.close)),
        actions: const [
          // if (!widget.isFromSignup!)
          //   GestureDetector(
          //     onTap: () {
          //       _appPaymentCubit.restorePurchase();
          //     },
          //     child: const Padding(
          //       padding: EdgeInsets.all(16.0),
          //       child: Text("Restore",
          //           style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.redAccent,
          //             fontWeight: FontWeight.w500,
          //           )),
          //     ),
          //   )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return !widget.isFromSignup!;
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Full Access\nAnd Move Forward',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Post feeds without limit',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Post stories without limit',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Connect with unlimited movers',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              Expanded(
                child: Column(
                  children: [
                    const Spacer(),
                    TrialStatement(
                      pId: _selectedProductId ?? '',
                    ),
                    // const SizedBox(
                    //   height: 32,
                    // ),
                    SubscriptionOptions(
                        subIds: _subIds,
                        onSubSelected: (id) {
                          _selectedProductId = id;
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<InAppPaymentCubit, InAppPaymentState>(
                      bloc: InAppPaymentCubit(injector.get())
                        ..fetchProduct(_selectedProductId!),
                      builder: (context, state) {
                        if (state is ProductsFetched) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Your account will be charged "
                              "${state.product.currencyCode} "
                              "${AppUtils.formatMoney(state.product.price)}"
                              " after 7 days trial period. "
                              "You can cancel your subscriptions to "
                              "avoid being charged 24 hours prior to "
                              "the end of the current period in "
                              "${Platform.isIOS ? 'App Store' : 'Playstore'}"
                              " account settings.",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const Spacer(),
                    BlocConsumer<InAppPaymentCubit, InAppPaymentState>(
                      bloc: _appPaymentCubit,
                      listener: (context, state) {
                        if (state is InAppPaymentError) {
                          AppUtils.showErrorDialog(context,
                              message: state.error.errorMessage,
                              title: "Subscription Error",
                              confirmButtonText: "Close",
                              onConfirmed: () => Navigator.pop(context));
                        }
                        if (state is InAppPurchaseSuccess) {
                          Navigator.pop(context, true);
                        }
                      },
                      builder: (context, state) {
                        return SafeArea(
                          top: false,
                          child: CustomButton(
                              color: Theme.of(context).colorScheme.secondary,
                              onTap: state is InAppPaymentLoading
                                  ? null
                                  : () {
                                      if (_selectedProductId != null) {
                                        _appPaymentCubit.purchaseStoreProduct(
                                            _selectedProductId!);
                                      }
                                    },
                              radius: 32,
                              isBusy: state is InAppPaymentLoading,
                              child: Text(
                                state is InAppPaymentLoading
                                    ? "Processing"
                                    : "Subscribe Now",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        );
                      },
                    ),
                    if (widget.isFromSignup!)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.blue),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Skip for now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
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
}

class TrialStatement extends StatelessWidget {
  final String pId;
  TrialStatement({
    Key? key,
    required this.pId,
  }) : super(key: key);

  final InAppPaymentCubit _appPaymentCubit = InAppPaymentCubit(injector.get());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<InAppPaymentCubit, InAppPaymentState>(
        bloc: _appPaymentCubit..fetchProduct(pId),
        builder: (context, state) {
          if (state is ProductsFetched) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: RichText(
                  // textAlign: TextAlign.justify,
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Try it out ',
                    style: TextStyle(
                      // fontSize: 14,
                      // fontFamily: "roboto",
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w400,
                    )),
                TextSpan(
                    text: ' 7 days ',
                    style: TextStyle(
                      // fontSize: 14,
                      // fontFamily: "roboto",
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: 'for free and then pay ',
                    style: TextStyle(
                      // fontSize: 14,
                      // fontFamily: "roboto",
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w400,
                    )),
                TextSpan(
                    text: '${state.product.priceString}/month',
                    style: TextStyle(
                      // fontSize: 14,
                      // fontFamily: "roboto",
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: ' after trial period ends.',
                    style: TextStyle(
                      // fontSize: 14,
                      // fontFamily: "roboto",
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w400,
                    )),
              ])),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class SubscriptionOptions extends StatefulWidget {
  final List<String> subIds;
  final Function(String) onSubSelected;
  const SubscriptionOptions({
    Key? key,
    required this.subIds,
    required this.onSubSelected,
  }) : super(key: key);

  @override
  State<SubscriptionOptions> createState() => _SubscriptionOptionsState();
}

class _SubscriptionOptionsState extends State<SubscriptionOptions> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.subIds.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SubscriptionItem(
                isActive: _activeIndex == index,
                subscriptionId: widget.subIds[index],
                onSelected: (id) {
                  setState(() {
                    widget.onSubSelected(id);
                    _activeIndex = index;
                  });
                },
              ),
            ));
  }
}

class SubscriptionItem extends StatefulWidget {
  final bool? isActive;
  final String subscriptionId;
  final Function(String subscriptionId) onSelected;
  const SubscriptionItem({
    Key? key,
    this.isActive = false,
    required this.subscriptionId,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<SubscriptionItem> createState() => _SubscriptionItemState();
}

class _SubscriptionItemState extends State<SubscriptionItem> {
  final InAppPaymentCubit _appPaymentCubit = InAppPaymentCubit(injector.get());

  @override
  void initState() {
    super.initState();
    _appPaymentCubit.fetchProduct(widget.subscriptionId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onSelected(widget.subscriptionId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          border: Border.all(
              color: widget.isActive! ? Colors.white : Colors.black12,
              width: 2),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio(
                  value: widget.isActive! ? 1 : 0,
                  groupValue: 1,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return Colors.black12;
                  }),
                  activeColor: Colors.white,
                  onChanged: (value) {},
                ),
                Text("Monthly",
                    style: TextStyle(
                        color: widget.isActive! ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ],
            ),
            BlocBuilder<InAppPaymentCubit, InAppPaymentState>(
              bloc: _appPaymentCubit,
              builder: (context, state) {
                if (state is ProductsFetched) {
                  return RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${state.product.priceString}/month",
                        style: TextStyle(
                            color: widget.isActive!
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 16))
                  ]));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
