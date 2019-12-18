import 'package:flutter/material.dart';

class GeneralInfo with ChangeNotifier {
  DateTime fromDate;
  DateTime toDate;
  bool isLoadingRestaurants = true;
  bool isLoadingCategories = true;
  int currentWeekdayIndex = 0;
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

  setWeekDayIndex(int value) {
    this.currentWeekdayIndex = value;
    notifyListeners();
  }

  setLoadingRestaurants(bool value) {
    this.isLoadingRestaurants = value;
    notifyListeners();
  }

  setLoadingCategories(bool value) {
    this.isLoadingCategories = value;
    notifyListeners();
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

  resetMenuFoodCategoryFilter() {
    _menuFoodCategoryFilter = [];
    notifyListeners();
  }

}