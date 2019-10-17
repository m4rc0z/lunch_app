import 'package:flutter/material.dart';

class GeneralInfo with ChangeNotifier {
  DateTime fromDate;
  DateTime toDate;
  List<DateTime> _weekDays;
  List<String> _foodCategoryFilter = [];

  List<DateTime> get weekDays  {
    return _weekDays != null ? [..._weekDays] : [];
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

  setDateRangeAndWeekDays(DateTime fromDate, DateTime toDate, List<DateTime> weekDays) {
    this.fromDate = fromDate;
    this.toDate = toDate;
    this._weekDays = weekDays;
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

  resetRestaurantFoodCategoryFilter() {
    _foodCategoryFilter = [];
    notifyListeners();
  }

}