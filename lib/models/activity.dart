import 'dart:convert';

import 'package:meta/meta.dart';

class Activity {
  final int id;
  final String who;
  final String what;
  final String where;
  final DateTime when;

  Activity({
    @required this.id,
    @required this.who,
    @required this.what,
    @required this.where,
    @required this.when,
  });

  Activity copyWith({
    String who,
    String what,
    String where,
    DateTime when,
  }) {
    return Activity(
      id: this.id,
      who: who ?? this.who,
      what: what ?? this.what,
      where: where ?? this.where,
      when: when ?? this.when,
    );
  }

  bool isOwner(String userId) {
    return who == userId;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'who': who,
      'what': what,
      'where': where,
      'when': when?.millisecondsSinceEpoch,
    };
  }

  static Activity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Activity(
      id: map['id'] as int,
      who: map['who'],
      what: map['what'],
      where: map['where'],
      when: DateTime.fromMillisecondsSinceEpoch(map['when']),
    );
  }

  String toJson() => json.encode(toMap());

  static Activity fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Activity(id: $id , who: $who, what: $what, where: $where, when: $when)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Activity &&
        o.id == id &&
        o.who == who &&
        o.what == what &&
        o.where == where &&
        o.when == when;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        who.hashCode ^
        what.hashCode ^
        where.hashCode ^
        when.hashCode;
  }
}
