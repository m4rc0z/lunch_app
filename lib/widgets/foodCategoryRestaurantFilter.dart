import 'package:flutter/material.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:provider/provider.dart';

import 'food_category_filter.dart';

class FoodCategoryRestaurantFilter extends StatelessWidget {
  final void Function(String) filterRestaurantFoodCategory;
  final List<String> foodCategoryFilter;

  FoodCategoryRestaurantFilter(this.filterRestaurantFoodCategory, this.foodCategoryFilter);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FoodCategoryFilter(
        Provider.of<FoodCategories>(context).restaurantFoodCategoryItems,
        this.foodCategoryFilter,
        this.filterRestaurantFoodCategory,
        'ALTERNATIVE ERNÄHRUNGSFORM'
      ),
    );
  }
}
