import 'package:equatable/equatable.dart';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/models/feed.dart';
import 'package:meta/meta.dart';

abstract class FeedState extends Equatable {
  const FeedState();
  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoaded extends FeedState {
  final Feed feed;
  const FeedLoaded(this.feed);

  @override
  List<Object> get props => [feed];
}

class FeedActivityAdded extends FeedState {
  final Feed feed;
  final Activity activity;
  FeedActivityAdded({@required this.feed, @required this.activity})
      : assert(feed != null),
        assert(activity != null);
}

class FeedActivityUpdated extends FeedState {
  final Feed feed;
  final Activity activity;
  FeedActivityUpdated({@required this.feed, @required this.activity})
      : assert(feed != null),
        assert(activity != null);
}

class FeedLoading extends FeedState {}

class FeedLoadFailure extends FeedState {
  final String error;
  FeedLoadFailure(this.error);
}
