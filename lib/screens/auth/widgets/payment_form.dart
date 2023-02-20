// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:creative_movers/cubit/in_app_payment_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/auth/widgets/details_saved_succes_dialog.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({Key? key, this.isFirstTime = false}) : super(key: key);

  final bool isFirstTime;

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  bool saveDetails = true;
  List<String> options = [
    'Start Free Trial For 7 days',
    'Pay \$7.00 now (Monthly Reoccuring Fee)'
  ];
  StoreProduct? _selectedProduct;

  var iapPaymentBloc = injector.get<InAppPaymentCubit>();

  @override
  void initState() {
    super.initState();
    iapPaymentBloc.fetchOfferings();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a payment plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'After your 7 day free trial period, you will be charged \$7.00 '
              'to enjoy all the services as well as all benefits '
              'of CreativeMovers  ',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: BlocBuilder<InAppPaymentCubit, InAppPaymentState>(
                bloc: InAppPaymentCubit(injector.get())..fetchOfferings(),
                builder: (context, state) {
                  if (state is InAppPaymentLoading) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (state is InAppPaymentFetchError) {
                    return Center(child: Text(state.error.errorMessage));
                  }
                  if (state is UpgradProductsFetched) {
                    log("PACKAGE: ${state.packages.first.toJson()}");
                    return ListView.builder(
                        itemCount: state.packages.length,
                        itemBuilder: (context, index) {
                          
                          return PaymentOptionsWidget(
                            storeProduct: state.packages[index].storeProduct,
                            includeTrial: widget.isFirstTime,
                            onSelected: (product) {
                              _selectedProduct = product;
                            },
                          );
                        });
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(
              height: 18,
            ),

            // const Spacer(),
            BlocConsumer<InAppPaymentCubit, InAppPaymentState>(
                bloc: iapPaymentBloc,
                listener: (context, state) {
                  if (state is InAppPaymentLoading) {
                    // AppUtils.showAnimatedProgressDialog(context,
                    //     title: "Processing");
                  }
                  if (state is InAppPaymentFetchError) {
                    // Navigator.of(context).pop();
                    AppUtils.showCustomToast(state.error.errorMessage);
                  }

                  if (state is InAppPurchaseSuccess) {
                    Navigator.of(context).pop();
                    if (widget.isFirstTime) {
                      showDialog(
                          context: context,
                          builder: (context) => WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: DetailsSavedDialog(
                                  paymentMode: "free",
                                  paymentType: "monthly",
                                  paymentAmount: "7.00",
                                  duration: "7",
                                  isFirstTime: widget.isFirstTime)),
                          barrierDismissible: false);
                    } else {
                      Navigator.of(context)
                        ..pop()
                        ..pop(true);
                      AppUtils.showCustomToast("Payment Successful");
                      // injector
                      //     .get<PaymentBloc>()
                      //     .add(const GetSubscriptionInfoEvent());
                    }
                  }
                },
                builder: (context, snapshot) {
                  return CustomButton(
                    child: const Text('CONTINUE'),
                    onTap: () async {
                      if (_selectedProduct != null) {
                        // iapPaymentBloc.fetchOfferings();
                        iapPaymentBloc.purchaseStoreProduct(_selectedProduct!.identifier);
                      }
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}

class PaymentOptionsWidget extends StatefulWidget {
  final bool includeTrial;
  final StoreProduct storeProduct;

  const PaymentOptionsWidget({
    Key? key,
    required this.onSelected,
    this.includeTrial = false,
    required this.storeProduct,
  }) : super(key: key);

  final Function(StoreProduct) onSelected;

  @override
  State<PaymentOptionsWidget> createState() => _PaymentOptionsWidgetState();
}

class _PaymentOptionsWidgetState extends State<PaymentOptionsWidget> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.5,
      child: ListView(
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0;
                widget.onSelected(widget.storeProduct);
              });
            },
            child: PaymentOptionCard(
              selected: selectedIndex == 0,
              title: widget.storeProduct.identifier == "com.creativemovers.m7"
                  ? "CreativeMovers Monthly"
                  : widget.storeProduct.title,
              description: widget.storeProduct.description,
              // description:
              //     'You will be charged \$7.00 on monthly bases to enjoy all the services as either creatives  or movers.',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       selectedIndex = 1;
          //       widget.onSelected('paid', "77", "yearly");
          //     });
          //   },
          //   child: PaymentOptionCard(
          //     selected: selectedIndex == 1,
          //     title: '\$77.00 / Year',
          //     description:
          //         'You will be charged \$7.00 on monthly bases to enjoy all the services as either creatives  or movers.',
          //   ),
          // ),
          const SizedBox(
            height: 16,
          ),
          // widget.includeTrial
          //     ? GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             selectedIndex = 2;
          //             widget.onSelected('trial', "0", "free");
          //           });
          //         },
          //         child: PaymentOptionCard(
          //           selected: selectedIndex == 2,
          //           title: '9 DAY FREE TRIAL',
          //           description:
          //               'Try and experience our features for 9 days and then you can pay for the full version.\n',
          //         ),
          //       )
          //     : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  const PaymentOptionCard(
      {Key? key,
      required this.selected,
      required this.title,
      required this.description})
      : super(key: key);

  final bool selected;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: selected ? AppColors.primaryColor : Colors.grey[100]!,
              width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: ListTile(
          leading: Icon(Icons.check_circle_rounded,
              color: selected ? AppColors.primaryColor : Colors.grey),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
