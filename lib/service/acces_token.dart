import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesToken {
  static const _keyAccesToken = 'accesToken';

  static Future<void> saveAccesToken(String? accesToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccesToken, accesToken!);
  }

  static Future<String> getAccesToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accesToken = prefs.getString(_keyAccesToken) ?? '';
    return accesToken;
  }

}
