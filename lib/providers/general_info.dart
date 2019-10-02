import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/restaurant.dart';
import 'foodCategory.dart';
import 'menu.dart';

class GeneralInfo with ChangeNotifier {
  DateTime fromDate;
  DateTime toDate;
  List<String> _foodCategoryFilter = [];

  List<String> get foodCategoryFilter {
    return [..._foodCategoryFilter];
  }

  setDateRange(DateTime fromDate, DateTime toDate) {
    this.fromDate = fromDate;
    this.toDate = toDate;
    notifyListeners();
  }

  toggleFoodCategory(String foodCategoryId) {
    if (foodCategoryFilter.contains(foodCategoryId)) {
      _foodCategoryFilter.remove(foodCategoryId);
    } else {
      _foodCategoryFilter.add(foodCategoryId);
    }
    notifyListeners();
  }

}