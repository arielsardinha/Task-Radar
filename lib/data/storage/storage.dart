abstract interface class StorageEnum<T extends Object> {
  final String key;

  StorageEnum({
    required this.key,
  });
}

abstract interface class Storage<T extends StorageEnum> {
  Future<void> setItem(T key, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getItem(T key);
  Future<void> removeItem(T key);
  Future<void> removeAll();

  Future<B?> getItemToFactory<B extends Object, C extends StorageEnum<B>>(
    C key, {
    required B Function(Map<String, dynamic> json) fromJson,
  });
}
