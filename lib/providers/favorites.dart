import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Favorites with ChangeNotifier {
  Future<void> _boxFuture;

  Favorites() {
    this.initDB();
  }

  Box<dynamic> _box;

  Future<void> initDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = appDir.path;
    Hive.init(path);
    var future = Hive.openBox('favoriteBox');
    _boxFuture = future;
    future.then((Box value) {
      _box = value;
    });
    return future;
  }

  toggleFavorite(String restaurantId) {
    if (_box == null) {
      _boxFuture.then((box) => {
          _setFavoriteStatusAndNotify(_box, restaurantId)
      });
    } else {
      _setFavoriteStatusAndNotify(_box, restaurantId);
    }
  }

  _setFavoriteStatusAndNotify(Box<dynamic> box, String restaurantId) {
    var favorite = box.get(restaurantId);
    if (favorite == null) {
      box.put(restaurantId, true);
    } else{
      box.put(restaurantId, !favorite);
    }
    notifyListeners();
  }

  bool getFavoriteStatus(String restaurantId) {
    if (_box == null) {
      return false;
    }
    var fav = _box.get(restaurantId);
    return fav != null ? fav : false;
  }

}