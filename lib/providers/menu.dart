import 'package:flutter/foundation.dart';

import 'course.dart';
import 'foodCategory.dart';

class Menu with ChangeNotifier {
  final String id;
  final String price;
  final DateTime date;
  final List<Course> courses;
  final List<FoodCategory> categories;

  Menu({
    @required this.id,
    @required this.price,
    @required this.date,
    @required this.courses,
    @required this.categories,
  });

}
