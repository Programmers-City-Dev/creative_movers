import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/data/remote/model/subscription_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/payment/views/subscription_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveSubscriptionScreen extends StatefulWidget {
  const ActiveSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<ActiveSubscriptionScreen> createState() =>
      _ActiveSubscriptionScreenState();
}

class _ActiveSubscriptionScreenState extends State<ActiveSubscriptionScreen> {
  final PaymentBloc _paymentBloc = PaymentBloc(injector.get());

  @override
  void initState() {
    super.initState();
    _paymentBloc.add(const GetSubscriptionInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Active Subscription',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Expanded(
              child: BlocConsumer<PaymentBloc, PaymentState>(
                bloc: _paymentBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is SubscriptionLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is SubscriptionLoadErrorState) {
                    return AppPromptWidget(
                      isSvgResource: true,
                      message: state.error,
                      onTap: () =>
                          _paymentBloc.add(const GetSubscriptionInfoEvent()),
                    );
                  }
                  if (state is SubscriptionLoadedState) {
                    SubscriptionResponse data = state.data;
                    if (data.user!.subscription != null) {
                      var subscription = data.user!.subscription;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                          subscription!.type ==
                                                  "account_activation"
                                              ? 'Account Activation'
                                              : 'Subscription',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                          subscription.status == "trial"
                                              ? "Free trial"
                                              : 'Monthly Subscription'),
                                      // trailing: Text('\$${subscription.amount}'),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        'Subscription Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: const Text(
                                          'This subscription was updated on this date.'),
                                      trailing: Text(AppUtils.getDateAndTime(
                                          subscription.updatedAt)),
                                    ),
                                    ListTile(
                                      title: const Text('Subscription Status',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle:
                                          const Text('Subscription Status'),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: subscription.status ==
                                                    "active"
                                                ? AppColors.lightBlue
                                                : subscription.status == "trial"
                                                    ? Colors.orange
                                                    : AppColors.red,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          subscription.status == "active"
                                              ? 'Active'
                                              : subscription.status == "trial"
                                                  ? "Free Trial"
                                                  : 'Inactive',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: subscription.status ==
                                                      "active"
                                                  ? AppColors.textColor
                                                  : AppColors.white),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Expiry Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      trailing: Text(AppUtils.getDateAndTime(
                                          subscription.expiryDate)),
                                      subtitle: const Text(
                                          'Your subscription will expire on this date.'),
                                    ),
                                    // ListTile(
                                    //   title: const Text(
                                    //     'Subscription Type',
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold),
                                    //   ),
                                    //   trailing: Text(
                                    //       subscription.status.toLowerCase() ==
                                    //               'trial'
                                    //           ? 'Not Active '
                                    //           : subscription.subType),
                                    //   // subtitle: const Text(''),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                            // const Spacer(),
                            const SizedBox(
                              height: 16,
                            ),
                            if (subscription.status.toLowerCase() != 'active')
                              CustomButton(
                                child: const Text('Subscribe Now'),
                                onTap: () {
                                  _navigateToPayment(context);
                                },
                              ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: Text("Subscription data not availble"),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToPayment(BuildContext context) async {
    bool? done = await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: ((context) => const SubscriptionScreen())));
    if (done != null && done) {
      _paymentBloc.add(const GetSubscriptionInfoEvent());
      injector.get<PaymentBloc>().add(const GetSubscriptionInfoEvent());
    }
  }
}
