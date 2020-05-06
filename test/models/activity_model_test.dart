import 'package:feed_app/models/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../fixtures/fixture_reader.dart';

void main() {
  group('Activity Model', () {
    test('isOwner should return true if who equals param', () {
      final username = 'John';
      final activity = Activity(
        id: "id",
        what: 'Play basketball',
        when: DateTime.now().add(const Duration(days: 2)),
        where: 'My house',
        who: username,
      );

      expect(activity.isOwner(username), true);
    });

    test('should map activity object from json', () {
      final jsonString = fixture('activity.json');
      final activity = Activity(
        id: "1",
        what: 'Watch movie',
        when: DateTime.fromMillisecondsSinceEpoch(1584487455),
        where: 'My house',
        who: 'libranner',
      );

      final result = Activity.fromJson(jsonString);
      expect(result, activity);
    });
  });
}
