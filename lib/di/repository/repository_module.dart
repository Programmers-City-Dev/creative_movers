
import 'package:creative_movers/data/remote/repository/auth_repository.dart';
import 'package:creative_movers/data/remote/repository/buisness_repository.dart';
import 'package:creative_movers/data/remote/repository/chat_repository.dart';
import 'package:creative_movers/data/remote/repository/connects_repository.dart';
import 'package:creative_movers/data/remote/repository/feed_repository.dart';
import 'package:creative_movers/data/remote/repository/notifications_repository.dart';
import 'package:creative_movers/data/remote/repository/payment_repository.dart';
import 'package:creative_movers/data/remote/repository/profile_repository.dart';
import 'package:creative_movers/data/remote/repository/status_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
//DEPENDENCIES RELATED TO AUTH
  _injectDependenciesRelatedToAuth(injector);

  //DEPENDENCIES RELATED TO PROFILE
  _injectDependenciesRelatedToProfile(injector);

  //DEPENDENCIES RELATED TO PAYMENT
  _injectDependenciesRelatedToPayment(injector);

  injector.registerLazySingleton(() => NotificationsRepository(injector.get()));
  injector.registerLazySingleton(() => FeedRepository(injector.get()));
  injector.registerLazySingleton(() => ConnectsRepository(injector.get()));
  injector.registerLazySingleton(() => StatusRepository(injector.get()));
  injector.registerLazySingleton(() => BuisnessRepository(injector.get()));
  injector.registerLazySingleton(() => ChatRepository(injector.get()));

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