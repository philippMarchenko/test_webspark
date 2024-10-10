import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const URL_FOR_SAVE = "URL_FOR_SAVE";

  late SharedPreferences prefs;

  Future<AppPrefs> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? getUrl() {
    return prefs.getString(URL_FOR_SAVE);
  }

  void saveUrl(String value) {
    prefs.setString(URL_FOR_SAVE, value);
  }
}
