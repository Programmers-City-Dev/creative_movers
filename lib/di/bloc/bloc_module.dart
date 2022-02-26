import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/nav/nav_bloc.dart';
import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
//DEPENDENCIES RELATED TO AUTH
  _injectDependenciesRelatedToAuth(injector);

  //DEPENDENCIES RELATED TO PROFILE
  _injectDependenciesRelatedToProfile(injector);

  //DEPENDENCIES RELATED TO PAYMENT
  _injectDependenciesRelatedToPayment(injector);

  injector.registerLazySingleton(() => NavBloc());
}

void _injectDependenciesRelatedToAuth(GetIt injector) {
  injector.registerLazySingleton(() => AuthBloc());
}

void _injectDependenciesRelatedToProfile(GetIt injector) {
  injector.registerLazySingleton(() => ProfileBloc(injector.get()));
}

void _injectDependenciesRelatedToPayment(GetIt injector) {
  injector.registerLazySingleton(() => PaymentBloc(injector.get()));
}
