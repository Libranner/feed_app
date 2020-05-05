import 'dart:convert';

class Activity {
  final String who;
  final String what;
  final String where;
  final DateTime when;

  Activity(
    this.who,
    this.what,
    this.where,
    this.when,
  );

  Activity copyWith({
    String who,
    String what,
    String where,
    DateTime when,
  }) {
    return Activity(
      who ?? this.who,
      what ?? this.what,
      where ?? this.where,
      when ?? this.when,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'who': who,
      'what': what,
      'where': where,
      'when': when?.millisecondsSinceEpoch,
    };
  }

  static Activity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Activity(
      map['who'],
      map['what'],
      map['where'],
      DateTime.fromMillisecondsSinceEpoch(map['when']),
    );
  }

  String toJson() => json.encode(toMap());

  static Activity fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Activity(who: $who, what: $what, where: $where, when: $when)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Activity &&
        o.who == who &&
        o.what == what &&
        o.where == where &&
        o.when == when;
  }

  @override
  int get hashCode {
    return who.hashCode ^ what.hashCode ^ where.hashCode ^ when.hashCode;
  }
}
