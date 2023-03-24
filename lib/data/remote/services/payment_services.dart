import 'dart:developer';
import 'dart:io';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaymentServices {
  PaymentServices();

  Future<void> init() async {
    int? userId = injector.get<CacheCubit>().cachedUser?.id;

    String? email = injector.get<CacheCubit>().cachedUser?.email;
    String? displayName = injector.get<CacheCubit>().cachedUser?.fullname;

    late final PurchasesConfiguration purchaseConfig;
    if (Platform.isAndroid) {
      purchaseConfig =
          PurchasesConfiguration("goog_brurElscbAFgxsuPonOPivXlPds");
    } else if (Platform.isIOS) {
      purchaseConfig =
          PurchasesConfiguration("appl_HrOEKIOWyOvuTklJuyeuveaeOji");
    }
    await Purchases.setLogLevel(LogLevel.debug);

    await Purchases.configure(purchaseConfig..appUserID = "${userId ?? ""}");

    // var logInResult = await Purchases.logIn("${userId ?? ""}");
    // if (logInResult.created) {
    //   log("Log in successful");
    // } else {
    //   log("Log in failed");
    // }
    await Purchases.setEmail(email ?? "");
    await Purchases.setDisplayName(displayName ?? "");
  }

  bool isSubcriptionActive(CustomerInfo customerInfo,
      {List<String>? entitlements}) {
    if (entitlements == null) {
      return customerInfo.entitlements.active.isNotEmpty;
    }
    return customerInfo.entitlements.active.keys
        .any((key) => entitlements.contains(key));
  }

  Future<CustomerInfo> purchasePackage(Package package) async {
    return await Purchases.purchasePackage(package);
  }

  Future<CustomerInfo> purchaseProduct(String identifier,
      {required PurchaseType type}) async {
    return await Purchases.purchaseProduct(identifier, type: type);
  }

  static void logout() {
    Purchases.logOut();
  }
}
