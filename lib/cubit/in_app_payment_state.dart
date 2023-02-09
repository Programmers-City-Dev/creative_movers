part of 'in_app_payment_cubit.dart';

abstract class InAppPaymentState extends Equatable {
  const InAppPaymentState();

  @override
  List<Object> get props => [];
}

class InAppPaymentInitial extends InAppPaymentState {}

class InAppPaymentLoading extends InAppPaymentState {}

class InAppPaymentProcessing extends InAppPaymentState {}

class InAppPaymentError extends InAppPaymentState {
  final ServerErrorModel error;

  const InAppPaymentError(this.error);

  @override
  List<Object> get props => [error];
}

class UpgradProductsFetched extends InAppPaymentState {
  final List<Package> packages;

  const UpgradProductsFetched(this.packages);

  @override
  List<Object> get props => [packages];
}
class ProductsFetched extends InAppPaymentState {
  final StoreProduct product;

  const ProductsFetched(this.product);

  @override
  List<Object> get props => [product];
}
class InAppPaymentFetchError extends InAppPaymentState {
  final ServerErrorModel error;

  const InAppPaymentFetchError(this.error);

  @override
  List<Object> get props => [error];
}

class InAppPurchaseSuccess extends InAppPaymentState {
  final CustomerInfo customerInfo;

  const InAppPurchaseSuccess({required this.customerInfo});

  @override
  List<Object> get props => [customerInfo];
}
