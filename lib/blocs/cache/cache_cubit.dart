import 'package:bloc/bloc.dart';
import 'package:creative_movers/data/local/dao/cache_user_dao.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:equatable/equatable.dart';

part 'cache_state.dart';

class CacheCubit extends Cubit<CacheState> {
  CacheCubit() : super(CacheInitial());

  void fetchCachedUserData() async {
    var dataList = await injector.get<CacheCachedUserDao>().getAllCache();
    CachedUser cachedUser = dataList.first;
    emit(CachedUserDataFetched(cachedUser: cachedUser));
  }
}
