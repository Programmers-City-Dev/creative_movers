import 'dart:async';
import 'dart:developer';

import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/services/payment_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'in_app_payment_state.dart';

class InAppPaymentCubit extends Cubit<InAppPaymentState> {
  final PaymentServices paymentServices;

  bool hasActiveSubscription = false;

  // List<PurchasableProduct> products = [];

  InAppPaymentCubit(this.paymentServices) : super(InAppPaymentInitial());

  Future<void> fetchOfferings() async {
    try {
      // var customerInfo = await Purchases.getCustomerInfo();
      // log(customerInfo.originalAppUserId);

      emit(InAppPaymentLoading());
      final available = await Purchases.canMakePayments();
      if (!available) {
        emit(const InAppPaymentFetchError(ServerErrorModel(
            errorMessage: "Store not available onthis device",
            statusCode: 400)));
        return;
      }

      var offerings = await Purchases.getOfferings();
      Offering? currentOffering = offerings.current;
      if (currentOffering == null) {
        emit(const InAppPaymentFetchError(ServerErrorModel(
            errorMessage: "No offerings available", statusCode: 400)));
        return;
      }
      // final products = await Purchases.getProducts([
      //   Constants.coinProfitExpertMonthly,
      //   Constants.coinProfitLeaderMonthly
      // ], type: PurchaseType.subs);
      // log("$products");
      emit(UpgradProductsFetched(currentOffering.availablePackages));
    } on PlatformException catch (e) {
      emit(InAppPaymentFetchError(
          ServerErrorModel(errorMessage: "${e.message}", statusCode: 400)));
    }
  }

  void purchaseStoreProduct(String productId,
      {PurchaseType type = PurchaseType.subs}) async {
    try {
      emit(InAppPaymentLoading());
      var activeSubsEntitlements =
          (await Purchases.getCustomerInfo()).entitlements.active;
      bool isActive = activeSubsEntitlements.keys.contains("pro");
      log("isActive: $isActive");
      if (isActive) {
        emit(const InAppPaymentError(ServerErrorModel(
            errorMessage:
                "You are already subscribed to this plan or already have an active subscription",
            statusCode: 400)));
      } else {
        log("Product: $productId");
        var customerInfo = await paymentServices.purchaseProduct(
          productId,
          type: type,
        );
        emit(InAppPurchaseSuccess(customerInfo: customerInfo));
      }
    } on PlatformException catch (ex) {
      log("ERROR: ${ex.message}");
      if (PurchasesErrorHelper.getErrorCode(ex) ==
          PurchasesErrorCode.purchaseCancelledError) {
        emit(InAppPaymentInitial());
      } else {
        emit(InAppPaymentFetchError(
            ServerErrorModel(errorMessage: "${ex.message}", statusCode: 400)));
      }
    }
  }

  void purchasePackage(Package package,
      {PurchaseType type = PurchaseType.subs}) async {
    try {
      emit(InAppPaymentProcessing());
      var customerInfo = await Purchases.getCustomerInfo();
      bool isActive = paymentServices.isSubcriptionActive(customerInfo, entitlements: ["pro"]);

      if (isActive) {
        emit(InAppPaymentInitial());
        emit(const InAppPaymentError(ServerErrorModel(
            errorMessage: "You are already subscribed to this plan",
            statusCode: 400)));
      } else {
        var customerInfoResult = await paymentServices.purchasePackage(
          package,
        );

        emit(InAppPurchaseSuccess(customerInfo: customerInfoResult));
      }
    } on PlatformException catch (ex) {
      if (PurchasesErrorHelper.getErrorCode(ex) ==
          PurchasesErrorCode.purchaseCancelledError) {
        emit(InAppPaymentInitial());
      } else {
        emit(InAppPaymentFetchError(
            ServerErrorModel(errorMessage: "${ex.message}", statusCode: 400)));
      }
    }
  }

  void fetchProduct(String productId) async {
    try {
      // var customerInfo = await Purchases.getCustomerInfo();
      // log(customerInfo.originalAppUserId);

      emit(InAppPaymentLoading());

      var product =
          await Purchases.getProducts([productId], type: PurchaseType.subs);
      if (product.isEmpty) {
        emit(const InAppPaymentFetchError(ServerErrorModel(
            errorMessage: "Product is not available", statusCode: 400)));
        return;
      }
      emit(ProductsFetched(product.first));
    } on PlatformException catch (e) {
      emit(InAppPaymentFetchError(
          ServerErrorModel(errorMessage: "${e.message}", statusCode: 400)));
    }
  }

  void restorePurchase() async {
    try {
      emit(InAppPaymentLoading());
      var customerInfo = await Purchases.restorePurchases();
      emit(InAppPurchaseSuccess(customerInfo: customerInfo));
    } on PlatformException catch (ex) {
      if (PurchasesErrorHelper.getErrorCode(ex) ==
          PurchasesErrorCode.purchaseCancelledError) {
        emit(InAppPaymentInitial());
      } else {
        emit(InAppPaymentFetchError(
            ServerErrorModel(errorMessage: "${ex.message}", statusCode: 400)));
      }
    }
  }
}
