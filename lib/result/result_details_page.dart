import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/result/result_list_page.dart';
import 'package:test_webspark/result/result_view_model.dart';
import '../algorithm/short_distance_executor.dart';

class ResultDetailsPage extends StatefulWidget {
  const ResultDetailsPage({super.key});
  static const routeName = '/result_details_screen_page';

  @override
  State<ResultDetailsPage> createState() => _ResultDetailsPageState();
}

class _ResultDetailsPageState extends State<ResultDetailsPage> {
  late ResultViewModel vm;
  late ShortDistanceTaskExecutor shortDistanceTaskExecutor;
  @override
  void initState() {
    vm = Provider.of<ResultViewModel>(context,listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final index = ModalRoute.of(context)!.settings.arguments as int;

    shortDistanceTaskExecutor = vm.shortDistanceController.resultTasks[index];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Preview page"),
        ),
      body: Column(
        children: [
          _buildGrid(),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16
                ),
                shortDistanceTaskExecutor.result.getStringViewForListNodes()),
          )
        ],
      ),
    );
  }

 Widget _buildGrid() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        for (int row = 0; row < shortDistanceTaskExecutor.rowSize; row++)
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int column = 0; column < shortDistanceTaskExecutor.columnSize; column++)
                Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: getDecorationForNode(row,column),
                        child: Center(
                          child: Text(
                            "($column,$row)",
                            style: TextStyle(color: getColorForBlockedItem(row, column)),
                          ),
                        ),
                      ),
                    )
                )
            ],
          ),
      ],
    ),
  );

  Decoration getDecorationForNode(int row, int column){
    return BoxDecoration(
      border: Border.all(color: getColorForBlockedItem(row, column)),
      color: shortDistanceTaskExecutor.isStartNode(row, column)
          ? Color(0xFF64FFDA)
          : shortDistanceTaskExecutor.isEndNode(row, column)
          ? Color(0xFF009688)
          : shortDistanceTaskExecutor.isNodeInPath(row, column)
          ? Color(0xFF4CAF50)
          : shortDistanceTaskExecutor.isNodeBlocked(row, column)
          ? Color(0xFF000000)
          : Color(0xFFFFFFFF),
    );
  }

  Color getColorForBlockedItem(int row, int column){
    return shortDistanceTaskExecutor.isNodeBlocked(row, column) ? Colors.white : Colors.black;
  }

  @override
  void dispose() {
    super.dispose();
  }

}
