import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/screens/restaurant_list_parent_screen.dart';
import 'package:provider/provider.dart';

import './providers/menus.dart';
import 'error_logger.dart';
import 'providers/restaurants.dart';

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();
  runZoned<Future<Null>>(() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(MyApp());
    });
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  ErrorLogger.logError(error, stackTrace);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Favorites>(builder: (_) => Favorites()),
        ChangeNotifierProxyProvider<Favorites, Restaurants>(
            initialBuilder: (BuildContext context) => Restaurants(null),
            builder: (_, favourites, restaurants) {
              restaurants.setProvider(favourites);
              return restaurants;
            }),
        ChangeNotifierProvider<Menus>(builder: (_) => Menus()),
        ChangeNotifierProvider<GeneralInfo>(builder: (_) => GeneralInfo()),
        ChangeNotifierProvider<FoodCategories>(
            builder: (_) => FoodCategories()),
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
        ),
        home:
            RestaurantListParentScreen(), // TODO: add parent to handle tab handling and call restaurantlistscreen inside this
      ),
    );
    ;
  }
}
