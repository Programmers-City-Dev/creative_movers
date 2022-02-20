part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  
  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentProcessingState extends PaymentState{
}

class PaymentConfirmedState extends PaymentState{
  final String message;

  const PaymentConfirmedState(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentIntentGottenState extends PaymentState{
  final Map<String, dynamic> intent;

  const PaymentIntentGottenState(this.intent);

  @override
  List<Object> get props => [intent];
}

class PaymentFailureState extends PaymentState{
  final String error;

  const PaymentFailureState(this.error);

  @override
  List<Object> get props => [error];
}
