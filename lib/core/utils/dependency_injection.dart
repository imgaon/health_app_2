final di = _Di();

class _Di {
  final Map<Type, dynamic> _di = {};

  void set<T>(T obj) {
    _di[T] = obj;
  }

  T get<T>() {
    if (_di.containsKey(T)) {
      return _di[T] as T;
    } else {
      throw Exception('No instance of type $T found.');
    }
  }
}