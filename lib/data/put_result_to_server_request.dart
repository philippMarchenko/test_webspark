// To parse this JSON data, do
//
//     final putResultToServerResponse = putResultToServerResponseFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final putResultToServerRequest = putResultToServerRequestFromJson(jsonString);


List<PutResultToServerItem> putResultToServerRequestFromJson(String str) => List<PutResultToServerItem>.from(json.decode(str).map((x) => PutResultToServerItem.fromJson(x)));

String putResultToServerRequestToJson(List<PutResultToServerItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PutResultToServerItem {
  String id;
  Result result;

  PutResultToServerItem({
    required this.id,
    required this.result,
  });

  factory PutResultToServerItem.fromJson(Map<String, dynamic> json) => PutResultToServerItem(
    id: json["id"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "result": result.toJson(),
  };
}

class Result {
  List<Step> steps;
  String path;

  Result({
    required this.steps,
    required this.path,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
    "path": path,
  };
}

class Step {
  String x;
  String y;

  Step({
    required this.x,
    required this.y,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    x: json["x"],
    y: json["y"],
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
  };
}
