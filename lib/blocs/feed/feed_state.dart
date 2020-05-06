import 'package:equatable/equatable.dart';
import 'package:feed_app/models/feed.dart';

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
  List<Object> get props => [];
}

class FeedLoading extends FeedState {}

class FeedLoadFailure extends FeedState {
  final String error;
  FeedLoadFailure(this.error);
}
