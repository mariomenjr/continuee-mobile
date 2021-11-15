import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<SharedPreferences> _getInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<String?> getChainId() async {
    return (await _getInstance()).getString("chainId");
  }

  static Future<bool> setChainId(String chainId) async {
    return (await _getInstance()).setString("chainId", chainId);
  }
}
