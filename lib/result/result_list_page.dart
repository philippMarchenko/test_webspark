import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/result/result_details_page.dart';
import 'package:test_webspark/result/result_view_model.dart';

import '../algorithm/node.dart';

class ResultListPage extends StatefulWidget {
  const ResultListPage({super.key});
  static const routeName = '/result_list_screen_page';

  @override
  State<ResultListPage> createState() => _ResultListPageState();
}


class _ResultListPageState extends State<ResultListPage> {
  late ResultViewModel vm;

  @override
  void initState() {
    vm = Provider.of<ResultViewModel>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Result list page"),
        ),
        body: ListView.builder(
          itemCount: vm.shortDistanceController.resultTasks.length,
            itemBuilder: (BuildContext ctxt, int index) {
            final item = vm.shortDistanceController.resultTasks[index];
              return Column(
                children: [
                  InkWell(
                    onTap:() {
                      Navigator.pushNamed(context, ResultDetailsPage.routeName,arguments: index);
                    },
                    child: Ink(
                      child: SizedBox(
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                              item.result.getStringViewForListNodes()
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                  )
                ],
              );
            },
                )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

extension ParseNodes on List<Node> {
  String getStringViewForListNodes() {
    var res = "";

    for(final (index,node) in indexed){
      if(index != length - 1){
        res = "$res(${node.column},${node.row})->";
      }
      else{
        res = "$res(${node.column},${node.row})";
      }
    }
    return res;
  }
}
