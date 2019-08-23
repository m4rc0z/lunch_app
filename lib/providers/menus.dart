import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/restaurant.dart';
import 'course.dart';
import 'menu.dart';

class Menus with ChangeNotifier {
  List<Menu> _items = [
  ];

  List<Menu> get items {
    return [..._items];
  }

  Future<void> fetchAndSetMenus(String restaurantId) async {
    print('id:  ' + restaurantId);
    var url = 'http://localhost:3005/api2/restaurants/' + restaurantId +
        '/menus';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<Menu> loadedMenus = [];
      extractedData.forEach((menu) {
        final List<Course> loadedCourses = [];

        menu['courses'].forEach((course) {
          loadedCourses.add(
              Course(
                  id: course['_id'],
                  course: course['course'],
                  description: course['description']
              )
          );
        });
        loadedMenus.add(Menu(id: menu['_id'], price: menu['date'], courses: loadedCourses));
      });
      _items = loadedMenus;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}