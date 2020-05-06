import 'dart:convert';

import 'package:feed_app/blocs/bloc/bloc.dart';
import 'package:feed_app/exceptions/server_exception.dart';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/models/feed.dart';
import 'package:feed_app/repositories/feed_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../fixtures/fixture_reader.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  FeedBloc _bloc;
  FeedRepository _feedRepository = MockFeedRepository();

  tearDown(() {
    _bloc.close();
  });

  setUp(() {
    _bloc = FeedBloc(feedRepository: _feedRepository);
  });

  Feed _testFeed() {
    final jsonMap = json.decode(fixture('feed.json'));
    return Feed.fromMap(jsonMap);
  }

  void setUpGoodFeedRepository() {
    when(_feedRepository.getFeed()).thenAnswer((_) async {
      return _testFeed();
    });
  }

  void setUpBadFeedRepository() {
    when(_feedRepository.getFeed()).thenThrow((_) async {
      return ServerException();
    });
  }

  group(
    'Feed BloC',
    () {
      test('initialState should be empty', () {
        setUpGoodFeedRepository();
        expect(_bloc.initialState, FeedInitial());
      });

      test(
        'should emit [FeedLoadFailure]',
        () {
          setUpBadFeedRepository();
          final expected = [
            FeedInitial(),
            FeedLoading(),
            FeedLoadFailure('error'),
          ];
          _bloc.add(FetchFeed());

          expectLater(_bloc.cast(), emitsInOrder(expected));
        },
      );

      test(
        'should emit [FeedLoading, FeedLoaded]',
        () {
          setUpGoodFeedRepository();
          final expected = [
            FeedInitial(),
            FeedLoading(),
            FeedLoaded(_testFeed()),
          ];
          _bloc.add(FetchFeed());

          expectLater(_bloc.cast(), emitsInOrder(expected));
        },
      );

      test(
        'should emit [FeedLoading, FeedActivityAdded]',
        () {
          final activity = Activity(
            id: 100,
            who: "who",
            what: "what",
            where: "where",
            when: DateTime.now(),
          );

          setUpGoodFeedRepository();
          final expected = [
            FeedInitial(),
            FeedLoading(),
            FeedActivityAdded(
              feed: _testFeed(),
              activity: activity,
            ),
          ];
          _bloc.add(
            AddActivityToFeed(
              feed: _testFeed(),
              activity: activity,
            ),
          );

          expectLater(_bloc.cast(), emitsInOrder(expected));
        },
      );

      test(
        'should emit [FeedLoading, FeedActivityUpdated]',
        () {
          final activity = Activity(
            id: 1,
            who: "who",
            what: "what",
            where: "where",
            when: DateTime.now(),
          );

          setUpGoodFeedRepository();
          final expected = [
            FeedInitial(),
            FeedLoading(),
            FeedActivityUpdated(
              feed: _testFeed(),
              activity: activity,
            ),
          ];
          _bloc.add(
            UpdateActivityOnFeed(
              feed: _testFeed(),
              activity: activity,
            ),
          );

          expectLater(_bloc.cast(), emitsInOrder(expected));
        },
      );
    },
  );
}
