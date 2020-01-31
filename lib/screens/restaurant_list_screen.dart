import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/widgets/my_flutter_app_icons.dart';
import 'package:lunch_app/widgets/restaurant_filter.dart';
import 'package:lunch_app/widgets/title_section.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../widgets/restaurants_list.dart';

class RestaurantsListScreen extends StatefulWidget {
  final void Function(int) navigateTo;

  RestaurantsListScreen(this.navigateTo);

  @override
  _RestaurantsListScreenState createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen>
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
                                'RESTAURANTS \nIN DEINER NÄHE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Material(
                                color: Color.fromRGBO(94, 135, 142, 1),
                                shadowColor: Colors.black.withOpacity(0.8),
                                elevation: 25.0,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: InkWell(
                                    child: new IconButton(
                                      icon: new Icon(
                                        MyFlutterApp.filter,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      onPressed: () => showFilter(context),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Expanded(
                        child: RestaurantsList(
                            Provider.of<GeneralInfo>(context)
                                .currentWeekdayIndex,
                            currentPosition,
                            false),
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

  void showFilter(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
        context: ctx,
        builder: (_) {
          return new RestaurantFilter(
              Provider.of<GeneralInfo>(context).restaurantCategoryFilter,
              Provider.of<GeneralInfo>(context).foodCategoryFilter,
          );
        });
  }
}
