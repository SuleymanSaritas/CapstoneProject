import 'package:flutter/material.dart';
import 'package:lego_market_app/features/model/products.dart';

import 'core/components/app_bar/bottom_navigation_bar.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  // Products.firestore = Firestore.instance;
  //Constants.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}
