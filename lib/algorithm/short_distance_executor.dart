
import 'package:flutter/widgets.dart';

import '../data/get_data_response.dart';
import 'element.dart';
import 'node.dart';

class ShortDistanceTaskExecutor{
  int rowSize = 0;
  int columnSize = 0;

  int? startRow = 0;
  int? startColumn = 0;

  int? goalRow = 0;
  int? goalColumn = 0;

  var blockedSellsCount = 0;
  var id = "";

  late List<List<PathElement>> grid;
  List<Node> result = [];
  Function(double)? onProgress;

  Future<ShortDistanceTaskExecutor> calculateTask(
      Task task) async {

    id = task.id;

    result.clear();

    final field = task.field;
    rowSize = field.length;
    columnSize = field.length;

    startRow = task.start.y;
    startColumn = task.start.x;

    goalRow= task.end.y;
    goalColumn = task.end.x;

    grid = initialGrid();
    initBlockedItems(field);

    await runFinder(result);

    result.add(Node(row: goalRow, column: goalColumn));

    return this;
  }

  void initBlockedItems(List<String> field){

    for(final (rowIndex,row) in field.indexed){
      var rowItems = row.split("");
      for(final (columnIndex,item) in rowItems.indexed){
        if(item == "X"){
          grid[rowIndex][columnIndex].blocked = true;
          blockedSellsCount++;
        }
      }
    }
  }

  List<List<PathElement>> initialGrid() {

    final List<List<PathElement>> grid = <List<PathElement>>[<PathElement>[]];

    for (int row = 0; row < rowSize; row++) {
      grid.add(<PathElement>[]);

      for (int column = 0; column < columnSize; column++) {
        grid[row].add(PathElement(row: row, column: column));
      }
    }

    return grid;
  }

  Future<void> runFinder(
      List<Node> result) async {

    final List<PathElement> queue = <PathElement>[]
      ..add(grid[startRow!][startColumn!]..visited = true);

    int currentRow;
    int currentColumn;

    PathElement currentPathElement = queue.removeAt(0);

    currentPathElement
      ..g = 0
      ..h = calculateHeuristic(
        row: currentPathElement.row!,
        column: currentPathElement.column!,
      );

    currentRow = currentPathElement.row!;
    currentColumn = currentPathElement.column!;

    while (grid[goalRow!][goalColumn!] != currentPathElement) {
      await Future<void>.delayed(const Duration(milliseconds: 10), () async {
        result.add(Node(row: currentPathElement.row, column: currentPathElement.column));

        await _addChild(
          row: currentRow - 1,
          column: currentColumn - 1,
          queue: queue,
          element: currentPathElement,
        );

        await _addChild(
          row: currentRow - 1,
          column: currentColumn,
          queue: queue,
          element: currentPathElement,
        );

        await _addChild(
          row: currentRow - 1,
          column: currentColumn + 1,
          queue: queue,
          element: currentPathElement,
        );

        await _addChild(
          row: currentRow,
          column: currentColumn - 1,
          queue: queue,
          element: currentPathElement,
        );

        await _addChild(
          row: currentRow,
          column: currentColumn + 1,
          queue: queue,
          element: currentPathElement,
        );
        await _addChild(
          row: currentRow + 1,
          column: currentColumn - 1,
          queue: queue,
          element: currentPathElement,
        );

        await _addChild(
          row: currentRow + 1,
          column: currentColumn,
          queue: queue,
          element: currentPathElement,
        );

        await _addChild(
          row: currentRow + 1,
          column: currentColumn + 1,
          queue: queue,
          element: currentPathElement,
        );

        currentPathElement = getBestChild(queue);

        currentRow = currentPathElement.row!;
        currentColumn = currentPathElement.column!;

      });
    }

    if(grid[goalRow!][goalColumn!] == currentPathElement){
      onProgress!(1.0);
    }

    _showShortestPath(currentPathElement);
  }

  Future<void> _addChild({
    required int row,
    required int column,
    required List<PathElement> queue,
    required PathElement element,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10), () {
      if (row >= 0 && column >= 0 && row < rowSize && column < columnSize) {
        if (!grid[row][column].visited && !grid[row][column].blocked) {
          final double h =
          calculateHeuristic(row: row, column: column);

          queue.add(
            grid[row][column]
              ..visited = true
              ..parent = element
              ..g = element.g
              ..h = h,
          );

          getProgress(queue);
        }
      }
    });
  }

  void getProgress(List<PathElement> queue){
    var totalSells = columnSize * rowSize;
    var unblockedSells = totalSells - blockedSellsCount;
    onProgress!(queue.length / (unblockedSells - 2));

  }
  PathElement getBestChild(List<PathElement> queue) {
    int minIndex = 0;
    double minValue = double.infinity;

    for (int i = 0; i < queue.length; i++) {
      if (queue[i].g + queue[i].h < minValue) {
        minIndex = i;
        minValue = queue[i].g + queue[i].h;
      }
    }

    return queue.removeAt(minIndex);
  }

  double calculateHeuristic({
    required int row,
    required int column}) =>
      ((row - goalRow!).abs() + (column - goalColumn!).abs()).toDouble();

  void _showShortestPath(PathElement goal) {
    PathElement pathElement = goal;

    while (pathElement.parent != null) {
      pathElement.inPath = true;
      pathElement = pathElement.parent!;
    }
  }

  bool isStartNode(int row, int column){
    return row == startRow && column == startColumn;
  }

  bool isEndNode(int row, int column){
    return row == goalRow && column == goalColumn;
  }

  bool isNodeInPath(int row, int column){
    return grid[row][column].inPath;
  }

  bool isNodeBlocked(int row, int column){
    return grid[row][column].blocked;
  }
}