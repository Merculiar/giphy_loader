import 'package:flutter/material.dart';
import 'package:giphy_loader/src/providers/giphy_provider.dart';
import 'package:giphy_loader/src/screens/home_screen.dart';
import 'package:giphy_loader/src/services/giphy_service.dart';
import 'package:provider/provider.dart';

import 'common/routing_names.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GiphyProvider(
        giphyService: GiphyService(),
      ),
      child: MaterialApp(
        title: 'Giphy Viewer',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          backgroundColor: Colors.grey,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 40),
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
            ),
          ),
        ),
        initialRoute: homeScreen,
        routes: {
          homeScreen: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
