import 'dart:async';
import 'dart:convert';

import 'package:giphy_loader/src/common/api_keys.dart';
import 'package:giphy_loader/src/models/languages.dart';
import 'package:giphy_loader/src/models/rating.dart';
import 'package:giphy_loader/src/models/type.dart';
import 'package:http/http.dart';

import 'package:giphy_loader/src/models/collection.dart';

class GiphyService {
  static final baseUri = Uri(scheme: 'https', host: 'api.giphy.com');

  final String _apiKey = apiBetaKey;
  final Client _client = Client();
  final String _apiVersion = 'v1';

  GiphyService();

  Future<GiphyCollection> search(
    String query, {
    int offset = 0,
    int limit = 4,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    String type = GiphyType.gifs,
  }) async {
    final giphyCollection = _fetchCollection(
      baseUri.replace(
        path: '$_apiVersion/$type/search',
        queryParameters: <String, String>{
          'q': query,
          'offset': '$offset',
          'limit': '$limit',
          'rating': rating,
          'lang': lang,
        },
      ),
    );
    return giphyCollection;
  }

  Future<GiphyCollection> _fetchCollection(Uri uri) async {
    final response = await _getWithAuthorization(uri);

    return GiphyCollection.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }

  Future<Response> _getWithAuthorization(Uri uri) async {
    Map<String, String> queryParams = Map.from(uri.queryParameters)
      ..putIfAbsent('api_key', () => _apiKey);

    final response =
        await _client.get(uri.replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw GiphyServiceError(response.statusCode, response.body);
    }
  }
}

class GiphyServiceError extends Error {
  final int statusCode;
  final String exception;

  GiphyServiceError(this.statusCode, this.exception);

  @override
  String toString() {
    return 'GiphyServiceError{statusCode: $statusCode, exception: $exception}';
  }
}
