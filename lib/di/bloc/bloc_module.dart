import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/blocs/nav/nav_bloc.dart';
import 'package:creative_movers/blocs/notification/notification_bloc.dart';
import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/blocs/status/status_bloc.dart';
import 'package:creative_movers/data/local/repository/deep_link/deep_link_repository.dart';
import 'package:creative_movers/data/local/repository/deep_link/deep_link_repository_impl.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
  injector.registerLazySingleton<DeepLinkRepo>(() => DeepLinkRepoImpl());

//DEPENDENCIES RELATED TO AUTH
  _injectDependenciesRelatedToAuth(injector);

  //DEPENDENCIES RELATED TO PROFILE
  _injectDependenciesRelatedToProfile(injector);

  //DEPENDENCIES RELATED TO PAYMENT
  _injectDependenciesRelatedToPayment(injector);

  injector.registerLazySingleton(() => NavBloc());
  injector.registerLazySingleton(() => FeedBloc(injector.get()));
  injector.registerLazySingleton(() => StatusBloc());
  injector.registerLazySingleton(() => ConnectsBloc());
  injector.registerLazySingleton(() => NotificationBloc());
  injector.registerLazySingleton(() => ChatBloc(injector.get()));
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
