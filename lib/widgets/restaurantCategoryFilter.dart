import 'package:flutter/material.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:provider/provider.dart';

import 'food_category_filter.dart';

class RestaurantCategoryFilter extends StatelessWidget {
  final void Function(String) filterRestaurantCategory;
  final List<String> restaurantCategoryFilter;

  RestaurantCategoryFilter(this.filterRestaurantCategory, this.restaurantCategoryFilter);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FoodCategoryFilter(
        Provider.of<FoodCategories>(context).restaurantCategoryItems,
        this.restaurantCategoryFilter,
        this.filterRestaurantCategory,
        'KÜCHENART'
      ),
    );
  }
}
