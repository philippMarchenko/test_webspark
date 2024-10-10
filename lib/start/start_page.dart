
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/process/process_page.dart';
import 'package:test_webspark/start/start_view_model.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  static const routeName = '/start_screen_page';

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late TextEditingController _controller;
  late StartPageViewModel vm;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    vm = Provider.of<StartPageViewModel>(context);

    var url  = "";

    if(vm.appPrefs.getUrl() != null){
      url = vm.appPrefs.getUrl()!;
    }

    _controller.text = url;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Home Page"),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              TextField(
                controller: _controller,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Set valid API base URL to continue"
                  )
              ),

              SizedBox(
                  child:
                  !vm.isLoading ? SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton(
                      child: Text("Start"),
                      onPressed: (){
                        bool validURL = Uri.parse(_controller.text).isAbsolute;
                        if(validURL){
                          vm.getData(_controller.text).then((response){
                            vm.shortDistanceController.initDataFor(response);

                            if(response != null){
                              Navigator.pushNamed(context, ProcessPage.routeName);
                            }
                            else{
                              context.showAlert("Request error. Please try again");
                            }
                          });
                        }
                        else{
                          context.showAlert("Please enter valid URL");
                        }
                      }),
                ) :
                    const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    )
              )
            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

extension AllertExt on BuildContext {
  void showAlert(String text,{Function? onClick}){
    showDialog(
        context: this,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                    onClick?.call();
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }
}
