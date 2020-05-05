import 'dart:convert';

import 'package:feed_app/exceptions/server_exception.dart';
import 'package:feed_app/models/feed.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class FeedRepository {
  /// Calls the http://api.com/feed endpoint. Returns a list of activities.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<Feed> getFeed();
}

class FeedRepositoryImpl implements FeedRepository {
  final http.Client httpClient;
  FeedRepositoryImpl({@required this.httpClient});
  final String url = 'https://api.com';

  @override
  Future<Feed> getFeed() async {
    final response = await httpClient
        .get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return Feed.fromMap(jsonMap);
    } else {
      throw ServerException();
    }
  }
}
