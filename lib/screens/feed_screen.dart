import 'package:feed_app/blocs/bloc/bloc.dart';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/models/feed.dart';
import 'package:feed_app/repositories/feed_repository.dart';
import 'package:feed_app/screens/shared/empty_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'activity/activity_detail_modal.dart';
import 'activity/activity_form_modal.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  FeedBloc _feedBloc;
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
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            child: ActivityFormModal(),
            useRootNavigator: false,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder(
      bloc: _feedBloc,
      builder: (context, state) {
        if (state is FeedLoaded) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
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

  Widget _buildActivityContainer(Activity activity) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          showDialog(
            context: context,
            child: ActivityDetailModal(activity: activity),
            useRootNavigator: false,
          );
        },
        child: Container(
          child: Column(
            children: [
              Text(activity.what),
              Text(activity.who),
              Text(activity.where),
              Text(activity.when.toIso8601String()),
            ],
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
    final acitivies = List.generate(10, (id) {
      return Activity(
        id: id,
        who: "Who $id",
        what: "What $id",
        where: "Where $id",
        when: DateTime.now(),
      );
    });

    return Feed(activities: acitivies);
  }
}