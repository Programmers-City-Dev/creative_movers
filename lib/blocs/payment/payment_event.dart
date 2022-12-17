part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class CreatePaymentIntentEvent extends PaymentEvent {
  final int amount;
  final String currency;
  final String duration;
  final String paymentFor;

  const CreatePaymentIntentEvent(
      this.amount, this.currency, this.duration, this.paymentFor);

  @override
  List<Object> get props => [amount, currency];
}

class MakePaymentEvent extends PaymentEvent {
  final String secrete;

  const MakePaymentEvent(this.secrete);

  @override
  List<Object> get props => [secrete];
}

class GetSubscriptionInfoEvent extends PaymentEvent {
  const GetSubscriptionInfoEvent();

  @override
  List<Object> get props => [];
}

class GetPaymentHistoryEvent extends PaymentEvent {
  const GetPaymentHistoryEvent();

  @override
  List<Object> get props => [];
}

class StartFreeTrialEvent extends PaymentEvent {}
