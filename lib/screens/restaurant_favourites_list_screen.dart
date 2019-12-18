import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/widgets/foodCategoryRestaurantFilter.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../widgets/restaurants_list.dart';

class RestaurantsFavouritesListScreen extends StatefulWidget {
  final void Function(int) navigateTo;

  RestaurantsFavouritesListScreen(this.navigateTo);

  @override
  _RestaurantsFavouritesListScreenState createState() => _RestaurantsFavouritesListScreenState();
}

class _RestaurantsFavouritesListScreenState extends State<RestaurantsFavouritesListScreen>
    with TickerProviderStateMixin {
  var _isInit = true;
  var weekdays;
  Position currentPosition;
  Geolocator geolocator = Geolocator();

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _getLocation().then((value) async {
        setState(() {
          currentPosition = value;
        });
      });
      var todayDateTime = DateTime.now();
      weekdays = DateUtil.getWeekDaysForDate(todayDateTime);
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
                        Provider.of<GeneralInfo>(context).currentWeekdayIndex,
                        widget.navigateTo
                )
                    : Container(),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: !Provider.of<GeneralInfo>(context).isLoadingRestaurants
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
                  child: RestaurantsList(Provider.of<GeneralInfo>(context).currentWeekdayIndex, currentPosition, true),
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