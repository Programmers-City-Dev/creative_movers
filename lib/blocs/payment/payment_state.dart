part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentProcessingState extends PaymentState {}

class PaymentConfirmedState extends PaymentState {
  final String message;

  const PaymentConfirmedState(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentIntentGottenState extends PaymentState {
  final Map<String, dynamic> intent;

  const PaymentIntentGottenState(this.intent);

  @override
  List<Object> get props => [intent];
}

class PaymentFailureState extends PaymentState {
  final String error;

  const PaymentFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class SubscriptionLoadingState extends PaymentState {}

class SubscriptionLoadedState extends PaymentState {
  final SubscriptionResponse data;

  const SubscriptionLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class SubscriptionLoadErrorState extends PaymentState {
  final String error;
  const SubscriptionLoadErrorState(this.error);
  @override
  List<Object> get props => [error];
}


class PaymentHistoryLoadingState extends PaymentState {}

class PaymentHistoryLoadedState extends PaymentState {
  final PaymentHistoryResponse data;

  const PaymentHistoryLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class PaymentHistoryLoadErrorState extends PaymentState {
  final String error;
  const PaymentHistoryLoadErrorState(this.error);
  @override
  List<Object> get props => [error];
}
