import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import 'foodCategory.dart';

class FoodCategories with ChangeNotifier {
  List<FoodCategory> _restaurantItems = [];

  List<FoodCategory> get restaurantItems {
    return [..._restaurantItems];
  }

  List<FoodCategory> _menuItems = [];

  List<FoodCategory> get menuItems {
    return [..._menuItems];
  }

  Future<void> fetchAndSetRestaurantCategories(DateTime fromDate, DateTime toDate) async {
    var url = environment['baseUrl'] + '/categories?fromDate='+ fromDate.toIso8601String() +'&toDate=' + toDate.toIso8601String();
    try {
      _restaurantItems = await prepareCategories(url);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetMenuCategories(DateTime fromDate, DateTime toDate) async {
    var url = environment['baseUrl'] + '/categories?fromDate='+ fromDate.toIso8601String() +'&toDate=' + toDate.toIso8601String();
    try {
      _menuItems = await prepareCategories(url);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
  
  Future<List<FoodCategory>> prepareCategories(url) async {
    final List<FoodCategory> loadedFoodCategories = [];
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as List<dynamic>;
    extractedData.forEach((foodCategoryData) {
      loadedFoodCategories.add(FoodCategory(
        id: foodCategoryData['_id'],
        description: foodCategoryData['description'],
      ));
    });
    return loadedFoodCategories;
  }
}