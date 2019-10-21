import 'package:flutter/material.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:provider/provider.dart';

import './providers/menus.dart';
import 'providers/restaurants.dart';
import 'screens/restaurant_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Restaurants>(builder: (_) => Restaurants()),
        ChangeNotifierProvider<Menus>(builder: (_) => Menus()),
        ChangeNotifierProvider<GeneralInfo>(builder: (_) => GeneralInfo()),
        ChangeNotifierProvider<FoodCategories>(builder: (_) => FoodCategories()),
        ChangeNotifierProvider<Favorites>(builder: (_) => Favorites()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: RestaurantsListScreen(),
      ),
    );
    ;
  }
}
