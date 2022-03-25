// To parse this JSON data, do
//
//     final activity = activityFromJson(jsonString);

import 'dart:convert';


class Activity {
  Activity({
    required this.id,
    required this.activity,
    required this.completed,
  });

  final String id;
  final String activity;
  final int completed;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"],
    activity: json["activity"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity": activity,
    "completed": completed,
  };

  static List<Activity> activityFromJson(String str) => List<Activity>.from(json.decode(str).map((x) => Activity.fromJson(x)));

  static String activityToJson(List<Activity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

}
