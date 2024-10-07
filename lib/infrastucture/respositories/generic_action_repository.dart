abstract class GenericActionRepository<T> {
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> remove(T item);
  Future<List<T>> getAll();
}
