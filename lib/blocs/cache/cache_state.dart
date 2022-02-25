part of 'cache_cubit.dart';

abstract class CacheState extends Equatable {
  const CacheState();

  @override
  List<Object> get props => [];
}

class CacheInitial extends CacheState {}

class CachedUserDataFetched extends CacheState {
  final CachedUser cachedUser;

  const CachedUserDataFetched({required this.cachedUser});

  @override
  List<Object> get props => [cachedUser];
}
