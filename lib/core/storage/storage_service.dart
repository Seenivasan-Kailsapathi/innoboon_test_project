import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences preference;

  StorageService._();

  static final StorageService instance = StorageService._();


  initializeSharedPreference() async{
    preference = await SharedPreferences.getInstance();
  }

  setGitHubUserName(String key, String value) async {
     await preference.setString(key, value);
  }

  String? getGitHubUserName(String key) {
    return preference.getString(key);
  }

  Future<bool> clearAll() async {
    return await preference.clear();
  }


  Future<void> setTokenValue(String key, String value) async {
    await preference.setString(key, value);
  }

  String? getTokenValue() {
    return  preference.getString("token");
  }

}
