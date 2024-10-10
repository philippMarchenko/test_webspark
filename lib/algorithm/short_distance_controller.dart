import 'package:flutter/widgets.dart';
import 'package:test_webspark/algorithm/short_distance_executor.dart';
import '../data/get_data_response.dart';

class ShortDistanceController{
  Function(bool,int,double)? onProgress;

  var progress = 0.0;
  var isCalculatingFinished = false;
  var isCalculating = false;

  List<ShortDistanceTaskExecutor> resultTasks = [];
  GetDataResponse? getDataResponse;

  void initDataFor(GetDataResponse? r){
    getDataResponse= r;
  }

  Future<List<ShortDistanceTaskExecutor>> executeTasks() async {
    resultTasks.clear();
    isCalculating = true;
    for (final (index,task) in getDataResponse!.data.indexed) {
      final executor = ShortDistanceTaskExecutor();
      executor.onProgress = ((progress){
         if(progress > this.progress){
           this.progress = (progress);
         }

         onProgress!(isCalculatingFinishedFun(index,progress),(index + 1),progress);
      });

      final resultTask = await executor.calculateTask(task);
      progress = 0.0;
      resultTasks.add(resultTask);
    }
    isCalculating = false;

    return resultTasks;
  }

  bool isCalculatingFinishedFun(int index,double progress){
    isCalculatingFinished = progress == 1.0 && (index + 1) == getDataResponse!.data.length;
    return isCalculatingFinished;
  }

  int getProgressInt(){
    return (progress * 100).toInt();
  }
}