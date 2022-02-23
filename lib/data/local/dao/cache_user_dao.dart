import 'package:creative_movers/data/local/dao/base_dao.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:sembast/sembast.dart';

class CacheUserDao extends BaseDao<User> {
  final Future<Database> database;
  final StoreRef store;

  CacheUserDao({required this.database, required this.store});

  @override
  Future deleteById(int id) async {
    await store.record(id).delete(await database);
  }

  @override
  Future<List<User>> getAllCache() async {
    final snapshots = await store.find(await database);
    return snapshots
        .map((snapshot) => User.fromMap(snapshot.value))
        .toList(growable: false);
  }

  @override
  Future update(User cacheUser) async {
    await store
        .record(cacheUser.id)
        .update(await database, cacheUser.toMap());
  }

  @override
  Future<int> insert(User cacheUser) async {
    return await store.add(await database, cacheUser.toMap());
  }

  @override
  Future deleteAll() async {
    // Clear all records from the store
    return await store.delete(await database);
  }

  @override
  Future<User> findById(id) async {
    User? cachedUser;
    final users = await getAllCache();
    if (users.isNotEmpty) {
      cachedUser =
          users.firstWhere((element) => element.id == id);
    }
    debugPrint("cachedUser is $cachedUser");
    return cachedUser!;
  }
}
