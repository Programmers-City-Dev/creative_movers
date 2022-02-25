import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
injector.registerLazySingleton(() => CacheCubit());
}
