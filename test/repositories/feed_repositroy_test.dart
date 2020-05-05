import 'dart:convert';
import 'package:feed_app/exceptions/server_exception.dart';
import 'package:feed_app/models/activity.dart';
import 'package:feed_app/repositories/feed_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  FeedRepository datasource;
  MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    datasource = FeedRepositoryImpl(httpClient: httpClient);
  });

  void setUpHttpClientSuccess() {
    when(
      httpClient.get(
        any,
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(fixture('feed.json'), 200),
    );
  }

  void setupHttpClientNotFound() {
    when(
      httpClient.get(
        any,
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        'Not found',
        404,
      ),
    );
  }

  group('Feed Remote Datasource', () {
    test(
      'should perform a get request',
      () {
        setUpHttpClientSuccess();
        datasource.getFeed();
        verify(
          httpClient.get(
            'https://api.com',
            headers: {"Content-Type": "application/json"},
          ),
        );
      },
    );

    test(
      'should return a list of activities',
      () async {
        setUpHttpClientSuccess();
        final jsonMap = json.decode(fixture('feed.json'));
        final rawData = jsonMap['data'] as List;
        final expectedResult = rawData.map((f) => Activity.fromMap(f)).toList();

        final feed = await datasource.getFeed();
        expect(feed.activities, equals(expectedResult));
      },
    );

    test(
      'should throw a ServerException when the response code is 404',
      () async {
        setupHttpClientNotFound();
        final call = datasource.getFeed;

        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
