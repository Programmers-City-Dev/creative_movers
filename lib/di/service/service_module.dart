import 'package:creative_movers/data/remote/services/payment_services.dart';
import 'package:get_it/get_it.dart';
// import 'package:groupkash/domain/services/dynamic_links_service.dart';
// import 'package:groupkash/domain/services/push_notification_service.dart';

Future<void> init(GetIt injector) async {
  // injector.registerLazySingleton(() => PushNotificationService());
  injector.registerLazySingleton(() => PaymentServices());
}
