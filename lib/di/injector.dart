import 'package:get_it/get_it.dart';
import 'package:creative_movers/di/network/network_module.dart'
    as network_module;
import 'package:creative_movers/di/local/local_module.dart' as local_module;
import 'package:creative_movers/di/repository/repository_module.dart'
    as repository_module;
import 'package:creative_movers/di/bloc/bloc_module.dart' as bloc_module;
import 'package:creative_movers/di/cubit/cubit_module.dart' as cubit_module;
import 'package:creative_movers/di/service/service_module.dart' as service_module;

final injector = GetIt.instance;

Future<void> setup() async {
  network_module.init(injector);
  local_module.init(injector);
  cubit_module.init(injector);
  repository_module.init(injector);
  bloc_module.init(injector);
   service_module.init(injector);
}
