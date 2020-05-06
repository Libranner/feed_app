import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:feed_app/models/activity.dart';

class Feed {
  final List<Activity> activities;
  Feed({this.activities}) {
    this.activities.sort((a, b) => a.when.compareTo(b.when));
  }

  Feed copyWith({
    List<Activity> activities,
  }) {
    return Feed(
      activities: activities ?? this.activities,
    );
  }

  Activity find(int id) {
    return activities.firstWhere((a) => a.id == id, orElse: () => null);
  }

  void removeActivity(int id) {
    activities.removeWhere((a) => a.id == id);
  }

  void updateActivity(Activity activity) {
    final index = activities.indexOf(find(activity.id), 0);
    activities.replaceRange(index, index + 1, [activity]);
  }

  Map<String, dynamic> toMap() {
    return {
      'activities': activities?.map((x) => x?.toMap())?.toList(),
    };
  }

  static Feed fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Feed(
      activities:
          List<Activity>.from(map['data']?.map((x) => Activity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static Feed fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Feed(activities: $activities)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Feed && listEquals(o.activities, activities);
  }

  @override
  int get hashCode => activities.hashCode;
}
