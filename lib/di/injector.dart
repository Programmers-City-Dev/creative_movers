import 'package:get_it/get_it.dart';
import 'package:creative_movers/di/network/network_module.dart'
    as NetworkModule;
import 'package:creative_movers/di/local/local_module.dart' as LocalModule;
import 'package:creative_movers/di/repository/repository_module.dart'
    as RepositoryModule;
import 'package:creative_movers/di/bloc/bloc_module.dart' as BlocModule;
import 'package:creative_movers/di/cubit/cubit_module.dart' as CubitModule;

final injector = GetIt.instance;

Future<void> setup() async {
  NetworkModule.init(injector);
  LocalModule.init(injector);
  CubitModule.init(injector);
  RepositoryModule.init(injector);
  BlocModule.init(injector);
}
