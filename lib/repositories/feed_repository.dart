import 'dart:convert';
import 'dart:io';

import 'package:feed_app/exceptions/server_exception.dart';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/models/feed.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class FeedRepository {
  /// Calls the http://api.com/feed endpoint. Returns a list of activities.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Feed> getFeed();

  /// POST to http://api.com/feed/ endpoint and creates a new activity.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> addActivity(Activity activity);

  /// PUT to http://api.com/feed/ endpoint and updates an activity.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> updateActivity(Activity activity);
}

class FeedRepositoryImpl implements FeedRepository {
  final http.Client httpClient;
  FeedRepositoryImpl({@required this.httpClient}) : assert(httpClient != null);
  final String _baseUrl = 'https://api.com';

  @override
  Future<Feed> getFeed() async {
    final response = await httpClient
        .get(_baseUrl, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return Feed.fromMap(jsonMap);
    } else {
      throw ServerException('ERROR GETTING FEED');
    }
  }

  @override
  Future<bool> addActivity(Activity activity) async {
    final response = await httpClient
        .post('$_baseUrl/activity', body: activity.toJson())
        .catchError((onError) {
      print(onError);
    });

    if (response.statusCode == 200) {
      return true;
    }
  }

  @override
  Future<bool> updateActivity(Activity activity) async {
    final response = await httpClient
        .put('$_baseUrl/activity/${activity.id}', body: activity.toJson())
        .catchError((onError) {
      print(onError);
    });

    if (response.statusCode == 200) {
      return true;
    }

    throw ServerException(response.body);
  }
}
