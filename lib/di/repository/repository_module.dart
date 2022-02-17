import 'package:creative_movers/repository/remote/auth_repository.dart';
import 'package:creative_movers/repository/remote/profile_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
//DEPENDENCIES RELATED TO AUTH
  _injectDependenciesRelatedToAuth(injector);

  //DEPENDENCIES RELATED TO PROFILE
  _injectDependenciesRelatedToProfile(injector);

}

void _injectDependenciesRelatedToAuth(GetIt injector) {
  injector.registerLazySingleton(() => AuthRepository(injector.get()));
}

void _injectDependenciesRelatedToProfile(GetIt injector) {
  injector.registerLazySingleton(() => ProfileRepository(injector.get()));
}