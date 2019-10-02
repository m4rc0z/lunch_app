import 'package:flutter/foundation.dart';

class FoodCategory with ChangeNotifier {
  final String id;
  final String description;

  FoodCategory({
    @required this.id,
    @required this.description,
  });

}
