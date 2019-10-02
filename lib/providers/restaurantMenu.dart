import 'package:flutter/foundation.dart';

import 'course.dart';
import 'menu.dart';

class RestaurantMenu with ChangeNotifier {
  final String id;
  final Menu menu;

  RestaurantMenu({
    @required this.id,
    @required this.menu,
  });

}
