import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/deep_link/deep_link_cubit.dart';
import 'package:creative_movers/cubit/in_app_payment_cubit.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
  injector.registerLazySingleton<DeepLinkCubit>(
      () => DeepLinkCubit(injector.get()));
  injector.registerLazySingleton(() => CacheCubit());
  injector.registerLazySingleton(() => InAppPaymentCubit(injector.get()));
}
