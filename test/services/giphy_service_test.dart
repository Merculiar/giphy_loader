import 'package:giphy_loader/src/models/collection.dart';
import 'package:giphy_loader/src/models/rating.dart';
import 'package:giphy_loader/src/services/giphy_service.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockClient extends Mock implements Client {}

Future<void> main() async {
  group('GiphyService', () {
    test('should search gifs', () async {
      final giphyService = GiphyService();

      final collection = await giphyService.search('dogs');

      expect(collection, const TypeMatcher<GiphyCollection>());
    });

    test('should return gifs with standard limit(4)', () async {
      final giphyService = GiphyService();

      final collection = await giphyService.search('dogs');

      expect(collection.data.length, 4);
    });

    test('should parse gifs correctly', () async {
      final giphyService = GiphyService();

      final collection = await giphyService.search('dogs');
      final gif = collection.data.first;
      expect(gif.rating, GiphyRating.g);
      expect(gif.type, 'gif');
    });
  });
}
