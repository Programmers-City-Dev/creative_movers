
import 'package:creative_movers/data/remote/repository/auth_repository.dart';
import 'package:creative_movers/data/remote/repository/payment_repository.dart';
import 'package:creative_movers/data/remote/repository/profile_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
//DEPENDENCIES RELATED TO AUTH
  _injectDependenciesRelatedToAuth(injector);

  //DEPENDENCIES RELATED TO PROFILE
  _injectDependenciesRelatedToProfile(injector);

  //DEPENDENCIES RELATED TO PAYMENT
  _injectDependenciesRelatedToPayment(injector);

}

void _injectDependenciesRelatedToAuth(GetIt injector) {
  injector.registerLazySingleton(() => AuthRepository(injector.get()));
}

void _injectDependenciesRelatedToProfile(GetIt injector) {
  injector.registerLazySingleton(() => ProfileRepository(injector.get()));
}

void _injectDependenciesRelatedToPayment(GetIt injector) {
  injector.registerLazySingleton(() => PaymentRepository(injector.get()));
}