import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/restaurants.dart';
import 'package:lunch_app/screens/restaurant_favourites_list_screen.dart';
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
        new RestaurantsListScreen(this.navigateTo),
        new RestaurantsFavouritesListScreen(this.navigateTo)
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
              Provider.of<GeneralInfo>(context).foodCategoryFilter,
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
                .fetchAndSetRestaurantCategories(
              weekdays[weekdays.indexOf(today)],
              weekdays[weekdays.indexOf(today)],
            );
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

    Provider.of<GeneralInfo>(context).resetRestaurantFoodCategoryFilter();

    try {
      await Provider.of<FoodCategories>(context)
          .fetchAndSetRestaurantCategories(
        weekdays[selectedIndex],
        weekdays[selectedIndex],
      );
    } catch (error) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Verbindungsprobleme')));
    } finally {
      Provider.of<GeneralInfo>(context).setLoadingCategories(false);
    }

    try {
      await Provider.of<Restaurants>(context).fetchAndSetRestaurants(
        Provider.of<GeneralInfo>(context).foodCategoryFilter,
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
      new RestaurantsListScreen(this.navigateTo),
      new RestaurantsFavouritesListScreen(this.navigateTo)
    ];
    this._tabController = new PageController(
      initialPage: currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
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
        unselectedItemColor: Color.fromRGBO(189, 187, 173, 1),
        items: [
          BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
                color: Color.fromRGBO(189, 187, 173, 1),
              ),
              activeIcon: new Icon(
                Icons.home,
                color: Color.fromRGBO(94, 135, 142, 1),
              ),
              title: Text('Home')),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.favorite,
              color: Color.fromRGBO(189, 187, 173, 1),
            ),
            activeIcon: new Icon(
              Icons.favorite,
              color: Color.fromRGBO(94, 135, 142, 1),
            ),
            title: Text('Favourites'),
          )
        ],
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
