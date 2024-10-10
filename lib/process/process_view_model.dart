
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:test_webspark/algorithm/short_distance_controller.dart';
import 'package:test_webspark/result/result_list_page.dart';

import '../data/put_result_to_server_request.dart';
import '../data/put_result_to_server_response.dart';
import '../di/service_locator.dart';

class ProcessViewModel extends ChangeNotifier{
  Dio dio = locator.get<Dio>();
  ShortDistanceController shortDistanceController = locator.get<ShortDistanceController>();

  var isLoading = false;
  PutResultToServerResponse? resultToServerResponse;

  Future<PutResultToServerResponse?> putResult(List<PutResultToServerItem> request) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await dio.post('https://flutter.webspark.dev/flutter/api',
          data: putResultToServerRequestToJson(request)
      );
      resultToServerResponse = PutResultToServerResponse.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      resultToServerResponse = PutResultToServerResponse.fromJson(Map<String, dynamic>.from(e.response!.data!));
    }

    isLoading = false;
    notifyListeners();

    return resultToServerResponse;
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