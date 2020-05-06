import 'package:equatable/equatable.dart';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/models/feed.dart';
import 'package:meta/meta.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
  @override
  List<Object> get props => [];
}

class FetchFeed extends FeedEvent {}

class FeedLoadSuccess extends FeedEvent {
  final Feed feed;
  FeedLoadSuccess(this.feed);
}

class AddActivityToFeed extends FeedEvent {
  final Feed feed;
  final Activity activity;

  const AddActivityToFeed({@required this.feed, @required this.activity})
      : assert(feed != null),
        assert(activity != null);

  @override
  List<Object> get props => [activity];

  @override
  String toString() => 'ActivityAdded { activity: $activity }';
}

class UpdateActivityOnFeed extends FeedEvent {
  final Feed feed;
  final Activity activity;

  const UpdateActivityOnFeed({@required this.feed, @required this.activity})
      : assert(feed != null),
        assert(activity != null);

  @override
  List<Object> get props => [activity];

  @override
  String toString() => 'ActivityUpdated { activity: $activity }';
}
