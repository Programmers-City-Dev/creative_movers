import 'dart:io';

import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaymentServices {
  PaymentServices();

  Future<void> init() async {
    String? userId = await StorageHelper.getString(StorageKeys.user_id);

    String? email = await StorageHelper.getString(StorageKeys.email);

    String? displayName = await StorageHelper.getString(StorageKeys.username);

    late final PurchasesConfiguration purchaseConfig;
    if (Platform.isAndroid) {
      purchaseConfig =
          PurchasesConfiguration("goog_brurElscbAFgxsuPonOPivXlPds");
    } else if (Platform.isIOS) {
      purchaseConfig =
          PurchasesConfiguration("appl_HrOEKIOWyOvuTklJuyeuveaeOji");
    }
    await Purchases.setLogLevel(LogLevel.debug);

    await Purchases.configure(purchaseConfig..appUserID = userId ?? "");

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
      {required PurchaseType type, required StoreProduct? product}) async {
    // return await Purchases.purchaseProduct(identifier, type: type);
    return await Purchases.purchaseStoreProduct(product!);
  }

  static void logout() {
    Purchases.logOut();
  }
}
