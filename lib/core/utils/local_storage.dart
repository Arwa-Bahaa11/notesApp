import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _boxName = 'userBox';
  static const String _tokenKey = 'token';
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Future<void> saveToken(String token) async {
    var box = Hive.box(_boxName);
    await box.put(_tokenKey, token);
  }

  static Future<void> saveUser(
      {required String name, required String email}) async {
    var box = Hive.box(_boxName);
    await box.put(_nameKey, name);
    await box.put(_emailKey, email);
  }

  static String? getToken() {
    var box = Hive.box(_boxName);
    return box.get(_tokenKey);
  }

  static String? getName() {
    var box = Hive.box(_boxName);
    return box.get(_nameKey);
  }

  static String? getEmail() {
    var box = Hive.box(_boxName);
    return box.get(_emailKey);
  }

  static Future<void> clearAll() async {
    var box = Hive.box(_boxName);
    await box.clear();
  }
}
