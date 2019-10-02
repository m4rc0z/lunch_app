import 'package:flutter/material.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/widgets/foodCategoryRestaurantFilter.dart';
import 'package:lunch_app/widgets/food_category_filter.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../widgets/day_selection.dart';
import '../widgets/restaurants_list.dart';
import '../providers/restaurants.dart';

class RestaurantsListScreen extends StatefulWidget {
  @override
  _RestaurantsListScreenState createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // TODO: adapt to use current week

      final weekdays = new DateUtil().getWeekDaysForDate(DateTime.now());
      if (weekdays.length > 0) {
        var fromDate = weekdays[0];
        var toDate = weekdays[6];

        Provider.of<GeneralInfo>(context).setDateRange(fromDate, toDate);
        Provider.of<Restaurants>(context)
            .fetchAndSetRestaurants(
            Provider.of<GeneralInfo>(context).foodCategoryFilter,
            Provider.of<GeneralInfo>(context).fromDate,
            Provider.of<GeneralInfo>(context).toDate)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
        Provider.of<FoodCategories>(context).fetchAndSetCategories(
            Provider.of<GeneralInfo>(context).fromDate,
            Provider.of<GeneralInfo>(context).toDate
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Container(
            child: Text(
              'LUNCH MENU',
              style: TextStyle(color: Colors.black),
            ),
          ),
          bottom: PreferredSize(
              child: Expanded(
                flex: 1,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: FoodCategoryRestaurantFilter(),
                ),
              ),
              preferredSize: Size.fromHeight(100)),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RestaurantsList(),
    );
  }
}
