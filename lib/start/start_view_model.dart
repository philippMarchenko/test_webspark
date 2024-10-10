import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:test_webspark/data/get_data_response.dart';
import 'package:test_webspark/algorithm/short_distance_controller.dart';
import 'package:test_webspark/local_storage/shared_preferences_manager.dart';
import 'package:test_webspark/result/result_list_page.dart';

import '../data/put_result_to_server_request.dart';
import '../data/put_result_to_server_response.dart';
import '../di/service_locator.dart';

class StartPageViewModel extends ChangeNotifier{
  Dio dio = locator.get<Dio>();
  AppPrefs appPrefs = locator.get<AppPrefs>();

  ShortDistanceController shortDistanceController = locator.get<ShortDistanceController>();

  GetDataResponse? getDataResponse;

  var isLoading = false;

  Future<GetDataResponse?> getData(String url) async {
    isLoading = true;
    notifyListeners();
    appPrefs.saveUrl(url);

    try{
      var response = await dio.get(url);
      getDataResponse = GetDataResponse.fromJson(Map<String, dynamic>.from(response.data));
    }catch(e){}

    isLoading = false;

    notifyListeners();
    return getDataResponse;
  }

  Future<PutResultToServerResponse?> putResult(List<PutResultToServerItem> request) async {
    final response = await dio.post('https://flutter.webspark.dev/flutter/api',
        data: putResultToServerRequestToJson(request)
    );
    final responseMapped =  PutResultToServerResponse.fromJson(Map<String, dynamic>.from(response.data));

    notifyListeners();
    return responseMapped;
  }

  List<PutResultToServerItem> geServerRequest(){

    final resultTasks = shortDistanceController.resultTasks;

    List<PutResultToServerItem> request = [];

    for(final resultTask in resultTasks){

      List<Step> steps = [];

      for(final node in resultTask.result){
         final step = Step(x: node.column.toString(), y: node.row.toString());
         steps.add(step);
      }

      final result = Result(
        path: resultTask.result.getStringViewForListNodes(),
        steps: steps);

      final item = PutResultToServerItem(
          id: resultTask.id,
          result: result);

      request.add(item);
    }

    return request ;
  }

  Future<dynamic> readTestJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    return data;
  }

}