import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/auth/widgets/details_saved_succes_dialog.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({Key? key, this.isFirstTime = false}) : super(key: key);

  final bool isFirstTime;

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  bool saveDetails = true;
  List<String> options = [
    'Start Free Trial For 9 days',
    'Pay \$7.00 now (Monthly Reoccuring Fee)'
  ];
  String selectedPaymentMode = 'free';

  String paymentType = '';

  String paymentAmount = '';

  String mDuration = '';

  @override
  Widget build(BuildContext context) {
    final trialPaymentBloc = PaymentBloc(injector.get());
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
              'Payment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const Text(
              'You will be charged \$7.00 to enjoy all the services as well as all benefits of creatives  or movers  ',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: PaymentOptionsWidget(
                includeTrial: widget.isFirstTime,
                onSelected: (type, amount, duration) {
                  paymentType = type;
                  paymentAmount = amount;
                  mDuration = duration;
                },
              ),
            ),
            const SizedBox(
              height: 18,
            ),

            // const Spacer(),
            BlocListener<PaymentBloc, PaymentState>(
              bloc: injector.get<PaymentBloc>(),
              listener: (context, state) {
                if (state is PaymentProcessingState) {
                  AppUtils.showAnimatedProgressDialog(context,
                      title: "Processing");
                }
                if (state is PaymentFailureState) {
                  Navigator.of(context).pop();
                  AppUtils.showCustomToast(state.error);
                }
                if (state is PaymentIntentGottenState) {
                  Navigator.of(context).pop();
                  injector
                      .get<PaymentBloc>()
                      .add(MakePaymentEvent(state.intent['client_secret']));
                }

                if (state is PaymentConfirmedState) {
                  if (widget.isFirstTime) {
                    showDialog(
                        context: context,
                        builder: (context) => WillPopScope(
                            onWillPop: () => Future.value(false),
                            child: DetailsSavedDialog(
                                paymentMode: selectedPaymentMode,
                                paymentType: paymentType,
                                paymentAmount: paymentAmount,
                                duration: mDuration,
                                isFirstTime: widget.isFirstTime)),
                        barrierDismissible: false);
                  } else {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                    AppUtils.showCustomToast(state.message);
                    injector
                        .get<PaymentBloc>()
                        .add(const GetSubscriptionInfoEvent());
                  }
                }
              },
              child: BlocConsumer<PaymentBloc, PaymentState>(
                  bloc: trialPaymentBloc,
                  listener: (context, state) {
                    if (state is PaymentConfirmedState) {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: DetailsSavedDialog(
                                paymentMode: selectedPaymentMode,
                                paymentType: paymentType,
                                paymentAmount: paymentAmount,
                                duration: mDuration,
                                isFirstTime: widget.isFirstTime,
                              )),
                          barrierDismissible: false);
                    }
                    if (state is PaymentFailureState) {
                      Navigator.of(context).pop();
                      AppUtils.showCustomToast(state.error);
                    }
                    if (state is PaymentProcessingState) {
                      AppUtils.showAnimatedProgressDialog(context,
                          title: "Processing request, please wait...");
                    }
                  },
                  builder: (context, snapshot) {
                    return CustomButton(
                      child: const Text('CONTINUE'),
                      onTap: () async {
                        if (paymentType == 'paid') {
                          injector.get<PaymentBloc>().add(
                              CreatePaymentIntentEvent(int.parse(paymentAmount),
                                  "usd", mDuration, "account_activation"));
                        } else {
                          trialPaymentBloc.add(StartFreeTrialEvent());
                        }
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class PaymentOptionsWidget extends StatefulWidget {
  final bool includeTrial;

  const PaymentOptionsWidget({
    Key? key,
    required this.onSelected,
    this.includeTrial = false,
  }) : super(key: key);

  final Function(String, String, String) onSelected;

  @override
  State<PaymentOptionsWidget> createState() => _PaymentOptionsWidgetState();
}

class _PaymentOptionsWidgetState extends State<PaymentOptionsWidget> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.onSelected('paid', '7', "monthly");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.5,
      child: ListView(
        // shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0;
                widget.onSelected('paid', "7", "monthly");
              });
            },
            child: PaymentOptionCard(
              selected: selectedIndex == 0,
              title: '\$7.00 / Month',
              description:
                  'You will be charged \$7.00 on monthly bases to enjoy all the services as either creatives  or movers.',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 1;
                widget.onSelected('paid', "77", "yearly");
              });
            },
            child: PaymentOptionCard(
              selected: selectedIndex == 1,
              title: '\$77.00 / Year',
              description:
                  'You will be charged \$7.00 on monthly bases to enjoy all the services as either creatives  or movers.',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          widget.includeTrial
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                      widget.onSelected('trial', "0", "free");
                    });
                  },
                  child: PaymentOptionCard(
                    selected: selectedIndex == 2,
                    title: '9 DAY FREE TRIAL',
                    description:
                        'Try and experience our features for 9 days and then you can pay for the full version.\n',
                  ),
                )
              : const SizedBox.shrink()
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
