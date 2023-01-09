import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:creative_movers/app_config.dart';
import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/data/remote/model/payment_history_data.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/data/remote/model/subscription_response.dart';
import 'package:creative_movers/data/remote/repository/payment_repository.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uuid/uuid.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<MakePaymentWithIntentEvent>(_mapMakePaymentEventToState);
    // on<MakePaymentEvent>(_mapMakePaymentEventToState);
    on<GetSubscriptionInfoEvent>(_mapGetSubscriptionInfoEventToState);
    on<GetPaymentHistoryEvent>(_mapGetPaymentHistoryEventToState);
    on<StartFreeTrialEvent>(_mapStartFreeTrialEventToState);
  }

  Future<Either<String, String>> makePayment(String secret) async {
    try {
      if (Platform.isAndroid) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: secret,
          appearance: const PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(
                  primary: AppColors.primaryColor)),
        ));
        await Stripe.instance.presentPaymentSheet();
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: secret,
                applePay: const PaymentSheetApplePay(merchantCountryCode: "US"),
                appearance: const PaymentSheetAppearance(
                    colors: PaymentSheetAppearanceColors(
                        primary: AppColors.primaryColor))));

        await Stripe.instance.presentApplePay(
            params: const ApplePayPresentParams(cartItems: [
          ApplePayCartSummaryItem.immediate(
              label: "CreativeMovers Monthly", amount: "1000")
        ], country: "Nigeria", currency: "NGN"));
      }
      return const Right("Payment successful");
    } catch (e) {
      log("Payment error: $e", name: "PaymentBloc");
      return const Left("Unable to process payment");
    }
  }

  Future<Either<ServerErrorModel, Map<String, dynamic>>> _createPaymentIntent(
      int amount, String currency, String duration, String paymentFor) async {
    try {
      var email = await StorageHelper.getString("email");
      String orderId = const Uuid().v1();
      Map<String, dynamic> body = {
        "amount": (amount * 100).toString(),
        "currency": currency,
        "payment_method_types[]": ["card"],
        "metadata": {
          "order_id": orderId,
          "email": email,
          "app_env": Constants.getFlavor == Flavor.dev
              ? "dev"
              : Constants.getFlavor == Flavor.staging
                  ? "staging"
                  : "prod",
          "amount": amount.toString(),
          "duration": duration,
          "payment_for": paymentFor
        },
      };
      var res = await repository.createPaymentIntent(body);
      if (res is SuccessState) {
        log("PAYMENT CREATED: ${res.value}");
        return Right(res.value);
      }
      if (res is ErrorState) {
        log("ERROR OCCURRED");
        return Left(ServerErrorModel(statusCode: 400, errorMessage: res.value));
      }
      return const Left(ServerErrorModel(
          statusCode: 400,
          errorMessage: "Something went wrong, please try again"));
    } catch (e) {
      return const Left(ServerErrorModel(
          statusCode: 400, errorMessage: "Unable to complete payment request"));
    }
  }
  //   FutureOr<void> _mapCreatePaymentIntentEventToState(
  //     CreatePaymentIntentEvent event, Emitter<PaymentState> emit) async {
  //   try {
  //     emit(PaymentProcessingState());
  //     var either = await _createPaymentIntent(
  //         event.amount, event.currency, event.duration, event.paymentFor);
  //     if (either.isLeft) {
  //       emit(PaymentFailureState(either.left.errorMessage));
  //     } else {
  //       emit(PaymentIntentGottenState(either.right));
  //     }
  //   } catch (e) {
  //     emit(const PaymentFailureState(
  //         "Unable to initialize payment, try again!"));
  //   }
  // }

  FutureOr<void> _mapMakePaymentEventToState(
      MakePaymentWithIntentEvent event, Emitter<PaymentState> emit) async {
    try {
      emit(PaymentProcessingState());
      var response = await _createPaymentIntent(
          event.amount, event.currency, event.duration, event.paymentFor);
      if (response.isLeft) {
        emit(PaymentFailureState(response.left.errorMessage));
      } else {
        // emit(PaymentIntentGottenState(response.right));
        String secret = response.right["client_secret"];
        var res = await makePayment(secret);
        if (res.isLeft) {
          emit(PaymentFailureState(res.left));
        } else {
          emit(PaymentConfirmedState(res.right));
        }
      }
    } catch (e) {
      emit(const PaymentFailureState(
          "Unable to initialize payment, try again!"));
    }
  }

  // FutureOr<void> _mapMakePaymentEventToState(
  //     MakePaymentEvent event, Emitter<PaymentState> emit) async {
  //   try {
  //     emit(PaymentProcessingState());
  //     var either = await makePayment(event.secrete);
  //     if (either.isLeft) {
  //       emit(PaymentFailureState(either.left));
  //     } else {
  //       emit(PaymentConfirmedState(either.right));
  //     }
  //   } catch (e) {
  //     emit(const PaymentFailureState(
  //         "Unable to initialize payment, try again!"));
  //   }
  // }

  FutureOr<void> _mapGetSubscriptionInfoEventToState(
      GetSubscriptionInfoEvent event, Emitter<PaymentState> emit) async {
    try {
      emit(SubscriptionLoadingState());
      var state = await repository.fetchActiveSubscription();
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(SubscriptionLoadErrorState(errorModel.errorMessage));
      } else if (state is SuccessState) {
        emit(SubscriptionLoadedState(state.value));
      }
    } catch (e) {
      emit(const SubscriptionLoadErrorState(
          "Could not load subscription data at the moment"));
    }
  }

  FutureOr<void> _mapGetPaymentHistoryEventToState(
      GetPaymentHistoryEvent event, Emitter<PaymentState> emit) async {
    try {
      emit(PaymentHistoryLoadingState());
      var state = await repository.fetchPaymentHistory();
      if (state is ErrorState) {
        ServerErrorModel errorModel = state.value;
        emit(PaymentHistoryLoadErrorState(errorModel.errorMessage));
      } else if (state is SuccessState) {
        PaymentHistoryResponse response = state.value;
        // log("RES:${response.user!.toMap()}");
        emit(PaymentHistoryLoadedState(response));
      }
    } catch (e) {
      emit(const PaymentHistoryLoadErrorState(
          "Could not load payment history data at the moment"));
    }
  }

  FutureOr<void> _mapStartFreeTrialEventToState(
      StartFreeTrialEvent event, Emitter<PaymentState> emit) async {
    try {
      emit(PaymentProcessingState());
      var response = await repository.startFreeTrial();
      if (response is ErrorState) {
        ServerErrorModel errorModel = response.value;
        emit(PaymentFailureState(errorModel.errorMessage));
      } else if (response is SuccessState) {
        emit(const PaymentConfirmedState("Free trial confirmed"));
      }
    } catch (e) {
      emit(const PaymentFailureState("Unable to complete request, try again!"));
    }
  }
}
