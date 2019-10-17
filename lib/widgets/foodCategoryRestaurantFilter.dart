import 'package:flutter/material.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/restaurants.dart';
import 'package:provider/provider.dart';

import 'food_category_filter.dart';

class FoodCategoryRestaurantFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    filterCategories(String id) {
      Provider.of<GeneralInfo>(context).toggleFoodCategory(id);
      Provider.of<Restaurants>(context).fetchAndSetRestaurants(
          Provider.of<GeneralInfo>(context).foodCategoryFilter,
          Provider.of<GeneralInfo>(context).fromDate,
          Provider.of<GeneralInfo>(context).toDate);
    }

    return Container(
      child: FoodCategoryFilter(
        Provider.of<FoodCategories>(context).restaurantItems,
        Provider.of<GeneralInfo>(context).foodCategoryFilter,
        filterCategories,
      ),
    );
  }
}
