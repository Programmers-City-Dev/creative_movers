import 'dart:developer';

import 'package:creative_movers/data/local/dao/cache_user_dao.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cache_state.dart';

class CacheCubit extends Cubit<CacheState> {
  CachedUser? cachedUser;

  CacheCubit() : super(CacheInitial());

  void fetchCachedUserData() async {
    try {
      var dataList = await injector.get<CacheCachedUserDao>().getAllCache();
      if (dataList.isNotEmpty) {
        CachedUser cachedUser = dataList.first;
        this.cachedUser = cachedUser;
        emit(CachedUserDataFetched(cachedUser: cachedUser));
      }
    } catch (e) {
      debugPrint("ERROR FETCHING: $e");
    }
  }

  void updateCachedUserData(CachedUser cachedUser) async {
    try {
      await injector.get<CacheCachedUserDao>().insert(cachedUser);
      var dataList = await injector.get<CacheCachedUserDao>().getAllCache();
      CachedUser user = dataList.first;
      this.cachedUser = user;
      log("INSERT: ${user.toMap()}");
      emit(CachedUserDataFetched(cachedUser: user));
    } catch (e) {
      debugPrint("ERROR UPDATING: $e");
    }
  }

  void clearCacheStorage() {
    injector.get<CacheCachedUserDao>().deleteAll();
  }
}
