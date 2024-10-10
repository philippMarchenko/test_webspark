import 'package:flutter/cupertino.dart';

import '../di/service_locator.dart';
import '../local_storage/shared_preferences_manager.dart';

class SplashViewModel extends ChangeNotifier {
  final appPrefsAsync = locator.getAsync<AppPrefs>();


  Future<void> init() async {

     return ;
  }
}
