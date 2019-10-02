import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/restaurants.dart';
import 'package:lunch_app/widgets/foodCategoryMenuFilter.dart';
import 'package:lunch_app/widgets/food_category_filter.dart';
import 'package:lunch_app/widgets/restaurant_detail_header.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../widgets/menus_list.dart';
import '../providers/menus.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String id;

  RestaurantDetailScreen(this.id);

  @override
  _RestaurantDetailScreenState createState() =>
      _RestaurantDetailScreenState(this.id);
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  var _isInit = true;
  var _isLoading = false;
  var menus;
  int _currentIndex = 0;
  PageController _tabController;
  var today = DateTime.now();
  List<DateTime> weekDays = [];
  List<Widget> _tabList;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final String restaurantId;

  _RestaurantDetailScreenState(this.restaurantId);

  @override
  void initState() {
    super.initState();
    this.weekDays = new DateUtil().getWeekDaysForDate(today);
    this.today = this.weekDays.firstWhere((weekDay) {
      return weekDay.day == today.day &&
          weekDay.month == today.month &&
          weekDay.year == today.year;
    });
    this._tabList = [
      ...this.weekDays.map((weekDay) {
        return MenusList(this.restaurantId, weekDay);
      })
    ];
    this._currentIndex = this.weekDays.indexOf(today);
    _tabController = new PageController(
      initialPage: this._currentIndex,
    );
  }

  @override
  void didChangeDependencies() {
    this.weekDays = new DateUtil().getWeekDaysForDate(today);
    this.today = this.weekDays.firstWhere((weekDay) {
      return weekDay.day == today.day &&
          weekDay.month == today.month &&
          weekDay.year == today.year;
    });
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Menus>(context)
          .fetchAndSetMenus(
              Provider.of<GeneralInfo>(context).foodCategoryFilter,
              this.restaurantId,
              Provider.of<GeneralInfo>(context).fromDate,
              Provider.of<GeneralInfo>(context).toDate)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var restaurant = Provider.of<Restaurants>(context)
        .items
        .firstWhere((r) => r.id == this.restaurantId);
    return Scaffold(
      body: Column(
          children: <Widget>[
            Container(
              height: 450,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Hero(
                    transitionOnUserGestures: true,
                    tag: 'restaurantHero' + this.restaurantId,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              'assets/test.jpg',
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 400,
                              child: Container(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                              ),
                            ),
                            Positioned(
                              top: 175,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: <Widget>[
                                  RestaurantDetailHeader(
                                    restaurant,
                                    this._currentIndex,
                                        (newPage) {
                                      this._tabController.jumpToPage(newPage);
                                    },
                                    this.weekDays,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AppBar(
                      leading: new IconButton(
                          icon: new Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 35,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: PageView(
                      controller: _tabController,
                      onPageChanged: (newPage) {
                        setState(() {
                          this._currentIndex = newPage;
                        });
                      },
                      children: _tabList,
                    ),
                  )
          ],
      ),
    );
  }
}