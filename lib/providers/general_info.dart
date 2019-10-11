import 'package:flutter/material.dart';

class GeneralInfo with ChangeNotifier {
  DateTime fromDate;
  DateTime toDate;
  bool _isFetching = false;
  List<String> _foodCategoryFilter = [];

  bool get isFetching  {
    return _isFetching;
  }

  List<String> get foodCategoryFilter {
    return [..._foodCategoryFilter];
  }
  List<String> _menuFoodCategoryFilter = [];

  List<String> get menuFoodCategoryFilter {
    return [..._menuFoodCategoryFilter];
  }

  initMenuFoodCategoryBasedOnRestaurantFoodCategory() {
    this._menuFoodCategoryFilter = [...this.foodCategoryFilter];
  }

  setFetching(bool fetching) {
    this._isFetching = fetching;
    notifyListeners();
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

  toggleMenuFoodCategory(String foodCategoryId) {
    if (menuFoodCategoryFilter.contains(foodCategoryId)) {
      _menuFoodCategoryFilter.remove(foodCategoryId);
    } else {
      _menuFoodCategoryFilter.add(foodCategoryId);
    }
    notifyListeners();
  }

}