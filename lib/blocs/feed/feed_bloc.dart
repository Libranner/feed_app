import 'dart:async';
import 'package:bloc/bloc.dart';
import 'feed_event.dart';
import 'feed_state.dart';
import 'package:feed_app/repositories/feed_repository.dart';
import 'package:meta/meta.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;

  FeedBloc({@required this.feedRepository}) : assert(feedRepository != null);

  @override
  FeedState get initialState => FeedInitial();

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is FetchFeed) {
      yield* _mapFetchFeedToState(event);
    } else if (event is AddActivityToFeed) {
      yield* _mapActivityAddedToState(event);
    } else if (event is UpdateActivityOnFeed) {
      yield* _mapActivityUpdatedToState(event);
    }
  }

  Stream<FeedState> _mapFetchFeedToState(FeedEvent event) async* {
    try {
      yield FeedLoading();
      final feed = await feedRepository.getFeed();
      yield FeedLoaded(feed);
    } catch (err) {
      yield FeedLoadFailure(err.toString());
    }
  }

  Stream<FeedState> _mapActivityAddedToState(AddActivityToFeed event) async* {
    try {
      yield FeedLoading();
      Future.delayed(Duration(seconds: 2));
      final feed = event.feed;
      feed.activities.add(event.activity);
      yield FeedLoaded(feed);
    } catch (err) {
      yield FeedLoadFailure(err.toString());
    }
  }

  Stream<FeedState> _mapActivityUpdatedToState(
      UpdateActivityOnFeed event) async* {
    try {
      yield FeedLoading();
      await Future.delayed(Duration(seconds: 2));
      final feed = event.feed;
      feed.updateActivity(event.activity);
      yield FeedLoaded(feed);
    } catch (err) {
      yield FeedLoadFailure(err.toString());
    }
  }
}
