import 'package:creative_movers/helpers/http_helper.dart';
import 'package:get_it/get_it.dart';

Future<void> init(GetIt injector) async {
  /** HttpHelper*/
  injector.registerFactory(() => HttpHelper());
}
