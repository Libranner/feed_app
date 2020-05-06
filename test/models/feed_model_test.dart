import 'dart:convert';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/models/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import '../fixtures/fixture_reader.dart';

void main() {
  Feed feed;
  setUp(() {
    final jsonMap = json.decode(fixture('feed.json'));
    feed = Feed.fromMap(jsonMap);
  });

  group('Feed Model', () {
    test('should be able to edit activity if isOwner', () {
      final id = "1";
      final activity = Activity(
        id: id,
        what: 'Play basketball',
        when: DateTime.now().add(const Duration(days: 2)),
        where: 'My hosuse',
        who: 'username',
      );
      feed.updateActivity(activity);
      expect(activity, feed.find(id));
    });

    test('should be able to remove an activity using id', () {
      final id = "id";
      feed.removeActivity(id);
      expect(null, feed.find(id));
    });
  });
}
