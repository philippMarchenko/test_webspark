// To parse this JSON data, do
//
//     final getDataResponse = getDataResponseFromJson(jsonString);

import 'dart:convert';

GetDataResponse getDataResponseFromJson(String str) => GetDataResponse.fromJson(json.decode(str));

String getDataResponseToJson(GetDataResponse data) => json.encode(data.toJson());

class GetDataResponse {
  bool error;
  String message;
  List<Task> data;

  GetDataResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory GetDataResponse.fromJson(Map<String, dynamic> json) => GetDataResponse(
    error: json["error"],
    message: json["message"],
    data: List<Task>.from(json["data"].map((x) => Task.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Task {
  String id;
  List<String> field;
  End start;
  End end;

  Task({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    field: List<String>.from(json["field"].map((x) => x)),
    start: End.fromJson(json["start"]),
    end: End.fromJson(json["end"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "field": List<dynamic>.from(field.map((x) => x)),
    "start": start.toJson(),
    "end": end.toJson(),
  };
}

class End {
  int x;
  int y;

  End({
    required this.x,
    required this.y,
  });

  factory End.fromJson(Map<String, dynamic> json) => End(
    x: json["x"],
    y: json["y"],
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
  };
}
