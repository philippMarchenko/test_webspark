import 'package:get_it/get_it.dart';
import 'package:test_webspark/data/dio_builder.dart';

import '../algorithm/short_distance_controller.dart';
import '../local_storage/shared_preferences_manager.dart';

final locator = GetIt.asNewInstance();

Future<void> setupLocator() async {

  locator.registerSingletonAsync<AppPrefs>(() async => await AppPrefs().init());

  locator.registerSingleton(DioBuilder.getDio());
  locator.registerSingleton(ShortDistanceController());
}
