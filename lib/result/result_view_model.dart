import 'package:flutter/cupertino.dart';

import '../di/service_locator.dart';
import '../algorithm/short_distance_controller.dart';

class ResultViewModel extends ChangeNotifier{
  ShortDistanceController shortDistanceController = locator.get<ShortDistanceController>();


}