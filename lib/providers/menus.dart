import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lunch_app/providers/restaurantMenu.dart';

import '../env.dart';
import '../error_logger.dart';
import 'course.dart';
import 'foodCategory.dart';
import 'menu.dart';

class Menus with ChangeNotifier {
  List<RestaurantMenu> _items = [
  ];

  List<RestaurantMenu> get items {
    return [..._items];
  }

  List<Menu> getMenuByDate(String restaurantId, DateTime date) {
    var filteredMenus = this._items
        .where(
            (restaurantMenu) =>
        restaurantMenu.id == restaurantId &&
            restaurantMenu.menu.date.day == date.day &&
            restaurantMenu.menu.date.month == date.month &&
            restaurantMenu.menu.date.year == date.year
        )
        .map((filteredItem) => filteredItem.menu)
        .toList();
    return filteredMenus.length > 0 ? filteredMenus : [];
  }

  Future<void> fetchAndSetMenus(String restaurantId, DateTime fromDate,
      DateTime toDate) async {
    var url = environment['baseUrl'] + '/restaurants/' + restaurantId +
        '/menus?fromDate=' + fromDate.toIso8601String() + '&toDate=' +
        toDate.toIso8601String();
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<Menu> loadedMenus = [];
      extractedData.forEach((menu) {
        final List<Course> loadedCourses = [];
        final List<FoodCategory> loadedFoodCategories = [];

        menu['courses'].forEach((course) {
          loadedCourses.add(
              Course(
                  id: course['_id'],
                  course: course['course'],
                  description: course['description']
              )
          );
        });

        menu['categories'].forEach((category) {
          loadedFoodCategories.add(
              FoodCategory(
                  id: category['_id'], description: category['description'])
          );
        });

        loadedMenus.add(
            Menu(
                id: menu['_id'],
                price: double.parse(menu['price'].toString().replaceAll(',', '.')),
                courses: loadedCourses,
                categories: loadedFoodCategories,
                date: DateTime.parse(menu['date'])));
      });
      _items = loadedMenus.map((menu) =>
          RestaurantMenu(id: restaurantId, menu: menu)).toList();
      notifyListeners();
    } catch (error) {
      ErrorLogger.logError(error);
    }
  }

}