import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Favorites with ChangeNotifier {
  Box<dynamic> _box;

  Future<void> initDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = appDir.path;
    Hive.init(path);
    var future = Hive.openBox('favoriteBox');
    future.then((Box value) {
        _box = value;
    });
    return future;
  }

  toggleFavorite(String restaurantId) {
    var favorite = _box.get(restaurantId);
    if (favorite == null) {
      _box.put(restaurantId, true);
    } else{
      _box.put(restaurantId, !favorite);
    }
    notifyListeners();
  }

  bool getFavoriteStatus(String restaurantId) {
    var fav = _box.get(restaurantId);
    return fav != null ? fav : false;
  }

}