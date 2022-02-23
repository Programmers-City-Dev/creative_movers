// A base Dao class for performing basic crud operations with sembast

abstract class BaseDao<T> {
  Future<int> insert(T value);

  Future update(T value);

  Future deleteById(int id);

  Future deleteAll();

  Future<List<T>> getAllCache();

  Future<T> findById(dynamic id);
}
