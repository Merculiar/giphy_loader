import 'package:flutter/material.dart';
import 'package:giphy_loader/src/widgets/giphy_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Giphy Viewer')),
      ),
      body: const GiphyGrid(),
    );
  }
}
