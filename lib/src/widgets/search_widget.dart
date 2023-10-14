import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_loader/src/providers/giphy_provider.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _textEditingController;

  late GiphyProvider giphyProvider;

  Timer? _debouncerTimer;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    giphyProvider = context.read<GiphyProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _debouncerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: _textEditingController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          hintText: 'Search gifs',
          suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.black),
              onPressed: () {
                setState(() {
                  _textEditingController.clear();

                });
              }),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.orange),
          ),
        ),
        autocorrect: false,
      ),
    );
  }

  _onSearchChanged(String text) {
    giphyProvider.clearData();
    if (_debouncerTimer?.isActive ?? false) {
      _debouncerTimer?.cancel();
    }
    _debouncerTimer = Timer(const Duration(milliseconds: 300), () {
      giphyProvider.searchText = text;
      giphyProvider.loadData();
    });
  }
}
