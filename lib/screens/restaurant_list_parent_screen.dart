import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/restaurants.dart';
import 'package:lunch_app/screens/restaurant_list_screen.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';

class RestaurantListParentScreen extends StatefulWidget {
  @override
  _RestaurantListParentScreenState createState() =>
      _RestaurantListParentScreenState();
}

class _RestaurantListParentScreenState
    extends State<RestaurantListParentScreen> {
  PageController _tabController;
  List<Widget> _tabList;
  var _isInit = true;
  var currentIndex = 0;
  List<DateTime> weekdays;
  StreamSubscription<Position> positionStream;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    this._tabController.dispose();
    this.positionStream.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this._tabList = [
        new RestaurantsListScreen(this.navigateTo, false),
        new RestaurantsListScreen(this.navigateTo, true),
      ];
      var todayDateTime = DateTime.now();
      weekdays = DateUtil.getWeekDaysForDate(todayDateTime);
      var today = weekdays.firstWhere((weekDay) {
        return weekDay.day == todayDateTime.day &&
            weekDay.month == todayDateTime.month &&
            weekDay.year == todayDateTime.year;
      });
      var todayIndex = weekdays.indexWhere((weekDay) {
        return weekDay.day == todayDateTime.day &&
            weekDay.month == todayDateTime.month &&
            weekDay.year == todayDateTime.year;
      });
      // TODO: check why this delayed is needed -> otherwise a exception happens
      Future.delayed(Duration.zero, () async {
        Provider.of<GeneralInfo>(context).setWeekDayIndex(todayIndex);
        Provider.of<GeneralInfo>(context).setLoadingRestaurants(true);
        Provider.of<GeneralInfo>(context).setLoadingCategories(true);
        if (weekdays.length > 0) {
          var fromDate = weekdays[0];
          var toDate = weekdays[6];
          Provider.of<GeneralInfo>(context)
              .setDateRangeAndWeekDays(fromDate, toDate, weekdays);
          try {
            await Provider.of<Restaurants>(context).fetchAndSetRestaurants(
              null,
              null,
              fromDate,
              toDate,
            );
          } catch (error) {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text('Verbindungsprobleme')));
          } finally {
            Provider.of<GeneralInfo>(context).setLoadingRestaurants(false);
          }
          try {
            await Provider.of<FoodCategories>(context)
                .fetchAndSetRestaurantMenuCategories(
              weekdays[weekdays.indexOf(today)],
              weekdays[weekdays.indexOf(today)],
            );
            await Provider.of<FoodCategories>(context)
                .fetchAndSetRestaurantCategories();
          } catch (error) {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text('Verbindungsprobleme')));
          } finally {
            Provider.of<GeneralInfo>(context).setLoadingCategories(
                false); // TODO: remove unused LoadingCategories
          }
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void navigateTo(selectedIndex) async {
    // TODO: use function
    Provider.of<GeneralInfo>(context).setWeekDayIndex(selectedIndex);
    Provider.of<GeneralInfo>(context).setLoadingRestaurants(true);
    Provider.of<GeneralInfo>(context).setLoadingCategories(true);

    try {
      await Provider.of<FoodCategories>(context)
          .fetchAndSetRestaurantMenuCategories(
        weekdays[selectedIndex],
        weekdays[selectedIndex],
      );
      await Provider.of<FoodCategories>(context)
          .fetchAndSetRestaurantCategories();
    } catch (error) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Verbindungsprobleme')));
    } finally {
      Provider.of<GeneralInfo>(context).setLoadingCategories(false);
    }

    try {
      await Provider.of<GeneralInfo>(context).setDateRangeAndWeekDays(
          weekdays[selectedIndex], weekdays[selectedIndex], weekdays);
      await Provider.of<Restaurants>(context).fetchAndSetRestaurants(
        Provider.of<GeneralInfo>(context).foodCategoryFilter,
        Provider.of<GeneralInfo>(context).restaurantCategoryFilter,
        weekdays[selectedIndex],
        weekdays[selectedIndex],
      );
    } catch (error) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Verbindungsprobleme')));
    } finally {
      Provider.of<GeneralInfo>(context).setLoadingRestaurants(false);
    }
  }

  @override
  void initState() {
    super.initState();
    var geoLocator = new Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geoLocator.checkGeolocationPermissionStatus().then((status) {
      if (status != GeolocationStatus.denied &&
          status != GeolocationStatus.disabled) {
        this.positionStream = geoLocator
            .getPositionStream(locationOptions)
            .listen((Position position) {
          if (position != null) {
            Provider.of<Restaurants>(context).setCurrentLocation(position);
          }
        });
        // TODO: check where to close the stream
      }
    });
    this._tabList = [
      new RestaurantsListScreen(this.navigateTo, false),
      new RestaurantsListScreen(this.navigateTo, true),
    ];
    this._tabController = new PageController(
      initialPage: currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
              ),
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            currentIndex: currentIndex,
            onTap: (newPage) {
              setState(() {
                currentIndex = newPage;
              });
              this._tabController.animateToPage(newPage,
                  duration: Duration(milliseconds: 300), curve: Curves.easeOut);
            },
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            selectedItemColor: Color.fromRGBO(94, 135, 142, 1),
            unselectedItemColor: Colors.black.withOpacity(0.5),
            items: [
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.home,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  activeIcon: new Icon(
                    Icons.home,
                    color: Color.fromRGBO(94, 135, 142, 1),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('HOME',
                      style: TextStyle(
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
              BottomNavigationBarItem(
                icon: new Icon(
                  Icons.favorite,
                  color: Colors.black.withOpacity(0.5),
                ),
                activeIcon: new Icon(
                  Icons.favorite,
                  color: Color.fromRGBO(94, 135, 142, 1),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('FAVOURITES',
                    style: TextStyle(
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w700,
                    ),),
                ),
              )
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _tabController,
        onPageChanged: (newPage) {
          setState(() {
            currentIndex = newPage;
          });
        },
        children: _tabList,
      ),
    );
  }
}
