// To parse this JSON data, do
//
//     final putResultToServerResponse = putResultToServerResponseFromJson(jsonString);

import 'dart:convert';

PutResultToServerResponse putResultToServerResponseFromJson(String str) => PutResultToServerResponse.fromJson(json.decode(str));

String putResultToServerResponseToJson(PutResultToServerResponse data) => json.encode(data.toJson());

class PutResultToServerResponse {
  bool? error;
  String? message;
  List<Datum>? data;

  PutResultToServerResponse({
    this.error,
    this.message,
    this.data,
  });

  factory PutResultToServerResponse.fromJson(Map<String, dynamic> json) => PutResultToServerResponse(
    error: json["error"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  bool correct;

  Datum({
    required this.id,
    required this.correct,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    correct: json["correct"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "correct": correct,
  };
}
