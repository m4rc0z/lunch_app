import 'package:flutter/material.dart';

class GeneralInfo with ChangeNotifier {
  DateTime fromDate;
  DateTime toDate;
  bool isLoadingRestaurants = true;
  bool isLoadingCategories = true;
  int currentWeekdayIndex = 0;
  List<DateTime> _weekDays;
  List<String> _foodCategoryFilter = [];
  List<String> _restaurantCategoryFilter = [];

  int get filterCounter  {
    return foodCategoryFilter.length + restaurantCategoryFilter.length;
  }

  List<DateTime> get weekDays  {
    return _weekDays != null ? [..._weekDays] : [];
  }

  List<String> get foodCategoryFilter {
    return [..._foodCategoryFilter];
  }

  List<String> get restaurantCategoryFilter {
    return [..._restaurantCategoryFilter];
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

  setDateRangeAndWeekDays(DateTime fromDate, DateTime toDate, List<DateTime> weekDays) {
    this.fromDate = fromDate;
    this.toDate = toDate;
    this._weekDays = weekDays;
    notifyListeners();
  }

  setFoodCategory(List<String> foodCategoryList) {
    this._foodCategoryFilter = foodCategoryList;
    notifyListeners();
  }

  setRestaurantCategory(List<String> restaurantCategoryList) {
    this._restaurantCategoryFilter = restaurantCategoryList;
    notifyListeners();
  }

}