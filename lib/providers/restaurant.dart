import 'package:flutter/foundation.dart';

import 'menu.dart';

class Restaurant with ChangeNotifier {
  final String id;
  final String name;
  final List<Menu> menus;

  Restaurant({
    @required this.id,
    @required this.name,
    @required this.menus,
  });

}
