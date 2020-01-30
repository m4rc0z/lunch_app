import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/widgets/title_section.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../widgets/restaurants_list.dart';

// TODO: reuse RestaurantListScreen and do not copy favorite screen
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

  Future<Position> _getLocation() {
    Future<Position> currentLocation;
    try {
      currentLocation =
          geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _getLocation().then((value) {
        currentPosition = value;
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
          title: Center(child: TitleSection()),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Expanded(
              flex: 2,
              child: Container(
                constraints: BoxConstraints.expand(),
                child: weekdays != null && weekdays.length > 0
                    ? WeekDayNavigationBar(
                    weekdays,
                    Provider.of<GeneralInfo>(context).currentWeekdayIndex,
                    widget.navigateTo)
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 18.0, top: 18.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'FAVORITEN RESTAURANTS \nIN DEINER NÄHE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ]),
                ),
                Expanded(
                  child: RestaurantsList(
                      Provider.of<GeneralInfo>(context)
                          .currentWeekdayIndex,
                      currentPosition,
                      true),
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
