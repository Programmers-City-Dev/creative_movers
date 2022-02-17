
import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
//DEPENDENCIES RELATED TO AUTH
  _injectDependenciesRelatedToAuth(injector);

  //DEPENDENCIES RELATED TO PROFILE
  _injectDependenciesRelatedToProfile(injector);

}

void _injectDependenciesRelatedToAuth(GetIt injector) {
  injector.registerLazySingleton(() => AuthBloc());
}

void _injectDependenciesRelatedToProfile(GetIt injector) {
  injector.registerLazySingleton(() => ProfileBloc());
}
