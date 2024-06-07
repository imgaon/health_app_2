import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._privateConstructor();

  static final Prefs instance = Prefs._privateConstructor();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("Prefs not initialized. Call init() first.");
    }
    return _prefs!;
  }
}