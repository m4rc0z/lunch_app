import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../env.dart';
import '../providers/restaurant.dart';
import 'menu.dart';

class Restaurants with ChangeNotifier {
  List<Restaurant> _items = [];

  List<Restaurant> get items {
    return [..._items];
  }

  Future<void> fetchAndSetRestaurants(List<String> foodCategoryFilter, DateTime fromDate, DateTime toDate) async {
    var url;
    if (foodCategoryFilter.length > 0) {
      url = environment['baseUrl'] + '/restaurants?categories=' + foodCategoryFilter.join(',') + '&fromDate='+ fromDate.toIso8601String() +'&toDate=' + toDate.toIso8601String();
    } else {
      url = environment['baseUrl'] + '/restaurants?fromDate='+ fromDate.toIso8601String() +'&toDate=' + toDate.toIso8601String();
    }
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<Restaurant> loadedRestaurant = [];
      extractedData.forEach((restaurantData) {
        final List<Menu> loadedMenus = [];
        restaurantData['menus'].forEach((menu) {
          loadedMenus.add(Menu(id: menu['_id'], price: menu['date']));
        });
        loadedRestaurant.add(Restaurant(
          id: restaurantData['RID'],
          name: restaurantData['name'],
          menus: loadedMenus,
        ));
      });
      _items = loadedRestaurant;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}