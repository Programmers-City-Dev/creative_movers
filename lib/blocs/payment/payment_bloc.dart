import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:creative_movers/models/server_error_model.dart';
import 'package:creative_movers/models/state.dart';
import 'package:creative_movers/repository/remote/payment_repository.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {

  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<CreatePaymentIntentEvent>(_mapCreatePaymentIntentEventToState);
    on<MakePaymentEvent>(_mapMakePaymentEventToState);
  }

  Future<Either<String, String>> makePayment(String secret) async{
    try{
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: secret,
        applePay: true,
        googlePay: true,
        style: ThemeMode.light,
        merchantCountryCode: "US",
        merchantDisplayName: "Creative Movers Pay",
      ));

      await Stripe.instance.presentPaymentSheet(parameters: secret);
      return const Right("Payment successful");

    }catch(e){
      print("Payment error: $e");
      return const Left("Unable to process payment");
    }
  }

  Future<Either<ServerErrorModel, Map<String, dynamic>>> _createPaymentIntent(int amount, String currency) async{
    try{
      Map<String, dynamic> body = {
        "amount": (amount * 100).toString(),
        "currency" : currency,
        "payment_method_types[]" : "card"
      };
      var res = await repository.createPaymentIntent(body);
      if(res is SuccessState){
        log("PAYMENT CREATED: ${res.value}");
        return Right(res.value);
      }
      if(res is ErrorState){
        log("ERROR OCCURRED");
        return Left(ServerErrorModel(statusCode: 400, errorMessage: res.value));
      }
      return Left(ServerErrorModel(statusCode: 400, errorMessage: "Something went wrong, please try again"));
    }catch(e){
      return Left(ServerErrorModel(statusCode: 400, errorMessage: "Unable to complete payment request"));
    }
  }


  FutureOr<void> _mapCreatePaymentIntentEventToState(CreatePaymentIntentEvent event, Emitter<PaymentState> emit) async{
    try{
      emit(PaymentProcessingState());
      var either = await _createPaymentIntent(event.amount, event.currency);
      if(either.isLeft){
        emit(PaymentFailureState(either.left.errorMessage));
      }else{
        emit(PaymentIntentGottenState(either.right));
      }
    }catch(e){
      emit(const PaymentFailureState("Unable to initialize payment, try again!"));
    }
  }

  FutureOr<void> _mapMakePaymentEventToState(MakePaymentEvent event, Emitter<PaymentState> emit) async{
    try{
      emit(PaymentProcessingState());
      var either = await makePayment(event.secrete);
      if(either.isLeft){
        emit(PaymentFailureState(either.left));
      }else{
        emit(PaymentConfirmedState(either.right));
      }
    }catch(e){
      emit(const PaymentFailureState("Unable to initialize payment, try again!"));
    }
  }
}
