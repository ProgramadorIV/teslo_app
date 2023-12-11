import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPreferences();

    switch (T) {
      case int:
        return prefs.getInt(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case List<String>:
        return prefs.getStringList(key) as T?;
      default:
        throw UnimplementedError('Not implemented for type: ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPreferences();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPreferences();

    switch (T) {
      case int:
        prefs.setInt(key, value as int);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      case List<String>:
        prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw UnimplementedError('Not implemented for type: ${T.runtimeType}');
    }
  }
}
