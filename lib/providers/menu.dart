import 'package:flutter/foundation.dart';

import 'course.dart';

class Menu with ChangeNotifier {
  final String id;
  final String price;
  final List<Course> courses;

  Menu({
    @required this.id,
    @required this.price,
    @required this.courses,
  });

}
