import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class Storage {
  static late Database _db;
  static final _store = StoreRef<String, dynamic>.main(); // Key-Value Store

  /// Initialize Sembast database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/storage.db';

    _db = await databaseFactoryIo.openDatabase(dbPath);
  }

  /// Save a value with a key
  static Future<void> save(String key, dynamic value) async {
    await _store.record(key).put(_db, value);
  }

  /// Get a stored value
  static Future<T?> get<T>(String key) async {
    final value = await _store.record(key).get(_db);
    return value as T?;
  }

  /// Remove a stored value
  static Future<void> remove(String key) async {
    await _store.record(key).delete(_db);
  }

  /// Clear all stored data
  static Future<void> clear() async {
    await _store.delete(_db);
  }
}
