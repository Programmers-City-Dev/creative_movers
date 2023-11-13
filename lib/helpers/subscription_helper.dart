import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/payment/views/subscription_screen.dart';
import 'package:flutter/material.dart';

class SubscriptionHelper {
 static bool hasActiveSubscription() {
    return injector.get<PaymentBloc>().hasActiveSubscription;
  }

  Future<void> performSubscriptionCheckAndNavigate({
    required BuildContext context,
    required Function onActiveSubscription,
    Function? onNoActiveSubscription,
  }) async {
    if (hasActiveSubscription()) {
      onActiveSubscription();
    } else {
      if (onNoActiveSubscription != null) {
        onNoActiveSubscription();
      } else {
        // No custom action specified, show the upgrade dialog
        AppUtils.showUpgradeDialog(context, onSubscribe: () async {
          // Handle the subscription process
          bool? done = await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: ((context) => const SubscriptionScreen()),
            ),
          );
          if (done != null && done) {
            Navigator.pop(context);
            // Optionally, trigger a refresh or reload after subscription is acquired.
            injector.get<PaymentBloc>().add(const GetSubscriptionInfoEvent());
          }
        });
      }
    }
  }
}
