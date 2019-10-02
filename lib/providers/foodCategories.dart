import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// TODO: optimizse imports
import '../env.dart';
import '../providers/restaurant.dart';
import 'foodCategory.dart';
import 'menu.dart';

class FoodCategories with ChangeNotifier {
  List<FoodCategory> _items = [];

  List<FoodCategory> get items {
    return [..._items];
  }

  Future<void> fetchAndSetCategories(DateTime fromDate, DateTime toDate) async {
    var url = environment['baseUrl'] + '/categories?fromDate='+ fromDate.toIso8601String() +'&toDate=' + toDate.toIso8601String();
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<FoodCategory> loadedFoodCategories = [];
      extractedData.forEach((foodCategoryData) {
        loadedFoodCategories.add(FoodCategory(
          id: foodCategoryData['_id'],
          description: foodCategoryData['description'],
        ));
      });
      _items = loadedFoodCategories;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}