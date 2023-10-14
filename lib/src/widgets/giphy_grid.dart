import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:giphy_loader/src/models/gif.dart';
import 'package:giphy_loader/src/providers/giphy_provider.dart';
import 'package:giphy_loader/src/widgets/search_widget.dart';
import 'package:provider/provider.dart';

class GiphyGrid extends StatefulWidget {
  const GiphyGrid({Key? key}) : super(key: key);

  @override
  State<GiphyGrid> createState() => _GiphyGridState();
}

class _GiphyGridState extends State<GiphyGrid> {
  late ScrollController _scrollController;

  late GiphyProvider giphyProvider;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    giphyProvider = context.read<GiphyProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<GiphyProvider>().list;
    return Column(
      children: [
        const SearchWidget(),
        Expanded(
          child: MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            controller: _scrollController,
            crossAxisCount: 2,
            itemCount: list.length,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            itemBuilder: (ctx, idx) {
              GiphyGif gif = list[idx];
              return _buildGif(gif);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGif(GiphyGif gif) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: gif.images == null || gif.images?.fixedWidth.webp == null
          ? Container()
          : Image.network(
              gif.images!.fixedWidth.webp!,
              semanticLabel: gif.title,
              gaplessPlayback: true,
              fit: BoxFit.fill,
              headers: const {'accept': 'image/*'},
            ),
    );
  }

  void _scrollListener() {
    if (_scrollController.positions.last.extentAfter <= 500) {
      giphyProvider.loadData();
    }
  }
}
