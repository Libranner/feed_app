import 'package:feed_app/blocs/feed/bloc.dart';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/models/feed.dart';
import 'package:feed_app/repositories/feed_repository.dart';
import 'package:feed_app/screens/shared/empty_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'activity/activity_detail_modal.dart';
import 'activity/activity_form_modal.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  FeedBloc _feedBloc;
  Feed _currentFeed = Feed(activities: []);
  final userId = 'user-id';

  @override
  void initState() {
    super.initState();
    _feedBloc = FeedBloc(feedRepository: FeedTestRepository());
    _feedBloc.add(FetchFeed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Feed'),
      ),
      backgroundColor: Colors.grey[100],
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewActivity,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewActivity() async {
    final activity = await showDialog<Activity>(
      context: context,
      builder: (_) => ActivityFormModal(),
      useRootNavigator: false,
    );

    if (activity != null) {
      _feedBloc.add(AddActivityToFeed(
        feed: _currentFeed,
        activity: activity,
      ));
    }
  }

  void _updateActivity(Activity oldActivity) async {
    final activity = await showDialog<Activity>(
      context: context,
      builder: (_) => ActivityFormModal(
        activity: oldActivity,
      ),
      useRootNavigator: false,
    );

    if (activity != null) {
      _feedBloc.add(UpdateActivityOnFeed(
        feed: _currentFeed,
        activity: activity,
      ));
    }
  }

  Widget _buildBody() {
    return BlocBuilder(
      bloc: _feedBloc,
      builder: (context, state) {
        if (state is FeedLoaded) {
          _currentFeed = state.feed;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: ListView.separated(
              itemBuilder: (_, index) => _buildActivityContainer(
                state.feed.activities[index],
              ),
              separatorBuilder: (_, index) => SizedBox(height: 20.0),
              itemCount: state.feed.activities.length,
            ),
          );
        }

        if (state is FeedLoadFailure) {
          return EmptyContentWidget(
            title: 'Error',
            message: 'Something went wrong',
          );
        }

        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  void _showActivityDetail(Activity activity) {
    showDialog(
      context: context,
      child: ActivityDetailModal(activity: activity),
      useRootNavigator: false,
    );
  }

  Widget _buildActivityContainer(Activity activity) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          activity.isOwner(userId)
              ? _updateActivity(activity)
              : _showActivityDetail(activity);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromRGBO(113, 221, 248, 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3.0,
                  spreadRadius: 0.7,
                  offset: const Offset(0, 0),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(activity.who),
                          Text(activity.formattedDate),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Column(
                  children: <Widget>[
                    const Divider(thickness: 1.0),
                    const SizedBox(height: 5.0),
                    Text(
                      activity.what,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _feedBloc.close();
    super.dispose();
  }
}

class FeedTestRepository implements FeedRepository {
  @override
  Future<Feed> getFeed() async {
    await Future.delayed(Duration(seconds: 2));
    final acitivies = List.generate(60, (id) {
      return Activity(
        id: Uuid().v1(),
        who: "John",
        what:
            "Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap",
        where: "Cool Place",
        when: DateTime.now(),
      );
    });

    return Feed(activities: acitivies);
  }
}
