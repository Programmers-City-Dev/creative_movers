import 'package:creative_movers/data/local/dao/cache_user_dao.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


Future<void> init(GetIt injector) async {
  injector.registerSingletonAsync<Database>(() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "creative_movers.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    return database;
  });

  injector.registerLazySingleton(
    () => CacheUserDao(
      database: injector.getAsync(),
      store: intMapStoreFactory.store("cachedUser"),
    ),
  );
}
