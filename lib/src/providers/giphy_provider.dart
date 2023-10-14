import 'package:flutter/cupertino.dart';
import 'package:giphy_loader/src/models/collection.dart';
import 'package:giphy_loader/src/models/gif.dart';
import 'package:giphy_loader/src/services/giphy_service.dart';

class GiphyProvider extends ChangeNotifier {
  GiphyProvider({required GiphyService giphyService})
      : _giphyService = giphyService;

  final GiphyService _giphyService;

  static const _limit = 10;

  bool _isLoading = false;
  int _offset = 0;

  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String newValue) {
    if (newValue != _searchText) {
      _searchText = newValue;
    }
  }

  GiphyCollection? _collection;

  List<GiphyGif> _list = [];
  List<GiphyGif> get list => _list;

  void clearData() {
    _collection = null;
    _list = [];
    notifyListeners();
  }

  Future<void> loadData() async {
    if (_isLoading || _collection?.pagination?.totalCount == _list.length) {
      return;
    }
    _isLoading = true;

    if (_collection == null) {
      _offset = 0;
    } else {
      _offset =
          _collection!.pagination!.offset + _collection!.pagination!.count;
    }
    if (_searchText.isNotEmpty) {
      _collection = await _giphyService.search(
        _searchText,
        limit: _limit,
        offset: _offset,
      );
      _list.addAll(_collection!.data);
      notifyListeners();
    }
    _isLoading = false;
  }
}
