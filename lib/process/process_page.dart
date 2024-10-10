
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/data/get_data_response.dart';
import 'package:test_webspark/process/process_view_model.dart';
import 'package:test_webspark/result/result_list_page.dart';
import 'package:test_webspark/start/start_page.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});
  static const routeName = '/process_screen_page';

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  late ProcessViewModel vm;
  var progressString = "0%";
  var progressDouble = 0.0;
  var text = "";

  @override
  void initState() {

    SchedulerBinding.instance?.addPostFrameCallback((_) async {

      vm.shortDistanceController.onProgress = (isCalculatingFinished,index,progress){
        if(progress > progressDouble){
          progressDouble = progress ;
        }
        setState(() {
          if(isCalculatingFinished){
            text = "All calculations has finished,you can send your results to server";
          }
          else{
            text = "Calculating task($index)";
          }
          progressString = "${vm.shortDistanceController.getProgressInt()}%";
        });
      };

      vm.shortDistanceController.executeTasks().then((result){

      });

    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    vm = Provider.of<ProcessViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Process Page"),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        text,
                        style: const TextStyle(
                            fontSize: 18),),

                      Text(
                        textAlign: TextAlign.center,
                        progressString,
                        style: const TextStyle(fontSize: 32),),

                      Visibility(
                        visible: !vm.shortDistanceController.isCalculatingFinished,
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 6.0,
                          progressColor: Theme.of(context).colorScheme.primary,
                          percent: vm.shortDistanceController.progress,

                        ),
                      ),

                      vm.isLoading?
                      const CircularProgressIndicator() : Container(),
                    ],
                  ),
                ),
              ),


              vm.shortDistanceController.isCalculatingFinished && !vm.isLoading ?
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Opacity(
                    opacity: !vm.isLoading ? 1.0 : 0.5,
                    child: FilledButton(
                        child: Text("Send result to server"),
                        onPressed: (){
                          vm.putResult(vm.geServerRequest()).then((response){
                            if(response!.error == false ){
                              context.showAlert("Result was sent to server, all is correct",
                                  onClick: (){
                                    Navigator.pushNamed(context, ResultListPage.routeName);
                                  });
                            }
                            else{
                              context.showAlert(response.message!,
                                onClick: (){

                                });
                            }
                          });
                        }),
                  ),
                )
              : Container(),
              ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void setFakeTask(GetDataResponse? r){
    r!.data[0].end.y = 5;
    r!.data[0].end.x = 5;


    r!.data[0].start.y = 5;
    r!.data[0].start.x = 0;

    r!.data[0].field = [
      "......",
      "..XX..",
      "..XX..",
      "..XX..",
      "..XX..",
      "..XX..",
    ];

    r!.data[1].end.y = 2;
    r!.data[1].end.x = 4;


    r!.data[1].start.y = 4;
    r!.data[1].start.x = 1;

    r!.data[1].field = [
      "......",
      "..XX..",
      "..XX..",
      "..XX..",
      "..XX..",
      "..XX..",
    ];
  }
}

