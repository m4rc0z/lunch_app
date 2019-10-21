import 'package:flutter/material.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/widgets/foodCategoryRestaurantFilter.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../widgets/restaurants_list.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';
import '../providers/restaurants.dart';

class RestaurantsListScreen extends StatefulWidget {
  @override
  _RestaurantsListScreenState createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen>
    with TickerProviderStateMixin {
  var _isInit = true;
  var _isLoadingRestaurants = false;
  var _isLoadingCategories = false;
  var currentIndex = 0;
  var weekdays;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Favorites>(context).initDB();
      var todayDateTime = DateTime.now();
      weekdays = new DateUtil().getWeekDaysForDate(todayDateTime);
      var today = weekdays.firstWhere((weekDay) {
        return weekDay.day == todayDateTime.day &&
            weekDay.month == todayDateTime.month &&
            weekDay.year == todayDateTime.year;
      });

      setState(() {
        _isLoadingRestaurants = true;
        _isLoadingCategories = true;
      });

      // TODO: check why this delayed is needed -> otherwise a exception happens
      Future.delayed(Duration.zero, () {
        if (weekdays.length > 0) {
          var fromDate = weekdays[0];
          var toDate = weekdays[6];
          setState(() {
            currentIndex = weekdays.indexOf(today);
          });
          Provider.of<GeneralInfo>(context)
              .setDateRangeAndWeekDays(fromDate, toDate, weekdays);
          Provider.of<Restaurants>(context)
              .fetchAndSetRestaurants(
            Provider.of<GeneralInfo>(context).foodCategoryFilter,
            fromDate,
            toDate,
          )
              .then((_) {
            setState(() {
              _isLoadingRestaurants = false;
            });
          });
          Provider.of<FoodCategories>(context)
              .fetchAndSetRestaurantCategories(
            weekdays[currentIndex],
            weekdays[currentIndex],
          )
              .then((_) {
            setState(() {
              _isLoadingCategories = false;
            });
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Center(
            child: Container(
              child: Text(
                'LUNCH MENU',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Expanded(
              flex: 2,
              child: Container(
                constraints: BoxConstraints.expand(),
                child: weekdays != null && weekdays.length > 0
                    ? WeekDayNavigationBar(
                        weekdays,
                        currentIndex,
                        (selectedIndex) {
                          // TODO: use function
                          setState(() {
                            currentIndex = selectedIndex;
                            _isLoadingCategories = true;
                            _isLoadingRestaurants = true;
                          });

                          Provider.of<GeneralInfo>(context)
                              .resetRestaurantFoodCategoryFilter();

                          Provider.of<FoodCategories>(context)
                              .fetchAndSetRestaurantCategories(
                            weekdays[selectedIndex],
                            weekdays[selectedIndex],
                          )
                              .then((_) {
                            setState(() {
                              _isLoadingCategories = false;
                            });
                          });

                          Provider.of<Restaurants>(context)
                              .fetchAndSetRestaurants(
                            Provider.of<GeneralInfo>(context)
                                .foodCategoryFilter,
                            weekdays[selectedIndex],
                            weekdays[selectedIndex],
                          )
                              .then((_) {
                            setState(() {
                              _isLoadingRestaurants = false;
                            });
                          });
                        },
                      )
                    : Container(),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: !_isLoadingCategories || !_isLoadingRestaurants
              ? Container(
                  // TODO: check how to set background color globally
                  child: Column(
                    children: <Widget>[
                      AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: FoodCategoryRestaurantFilter(),
                        ),
                      ),
                      Expanded(
                        child: RestaurantsList(currentIndex),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ));
  }
}
