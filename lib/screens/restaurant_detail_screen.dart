import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/restaurants.dart';
import 'package:lunch_app/widgets/foodCategoryMenuFilter.dart';
import 'package:lunch_app/widgets/restaurant_detail_header.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../providers/menus.dart';
import '../widgets/menus_list.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String id;
  final int currentIndex;

  RestaurantDetailScreen(this.id, this.currentIndex);

  @override
  _RestaurantDetailScreenState createState() =>
      _RestaurantDetailScreenState(this.id, this.currentIndex);
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> with TickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;
  var _restaurant;
  var menus;
  PageController _tabController;
  var today = DateTime.now();
  List<DateTime> weekDays = [];
  List<Widget> _tabList;

  var currentIndex;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final String restaurantId;

  _RestaurantDetailScreenState(this.restaurantId, this.currentIndex);

  @override
  void initState() {
    super.initState();
    this.weekDays = new DateUtil().getWeekDaysForDate(today);
    this._tabList = [
      ...this.weekDays.map((weekDay) {
        return MenusList(this.restaurantId, weekDay);
      }),
    ];
    _tabController = new PageController(
      initialPage: this.currentIndex,
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
        _restaurant = Provider.of<Restaurants>(context)
            .items
            .firstWhere((r) => r.id == this.restaurantId);
      });

      Provider.of<FoodCategories>(context)
          .fetchAndSetMenuCategories(
        this.weekDays[currentIndex],
        this.weekDays[currentIndex],
      );

      Provider.of<Menus>(context)
          .fetchAndSetMenus(
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

  void updateCategoriesAndResetFilters(newPage) {
    Provider.of<GeneralInfo>(context).resetMenuFoodCategoryFilter();

    Provider.of<FoodCategories>(context).setMenuCategories(
        Provider.of<Menus>(context).getMenuByDateAndCategory(this.restaurantId, weekDays[newPage], Provider.of<GeneralInfo>(context).menuFoodCategoryFilter)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
            children: <Widget>[
              Container(
                height: 350,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: 'restaurantHero' + this.restaurantId,
                        child: Material(
                          type: MaterialType.transparency,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                            child: Container(
                              child: Image.asset( // TODO: remove this asset and load real image
                                'assets/test.jpg',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          ),
                        ),
                    ),
                    Positioned(
                      top: 175,
                      left: 0,
                      right: 0,
                      child: RestaurantDetailHeader(
                        _restaurant,
                        this.currentIndex,
                            (newPage) {
                              updateCategoriesAndResetFilters(newPage);
                                  // TODO: fetch and set categories for menuCategories -> add new function
                          this._tabController.jumpToPage(newPage);
                        },
                        this.weekDays,
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
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: new IconButton(
                              icon: new Icon(
                                Provider.of<Favorites>(context).getFavoriteStatus(restaurantId) ?
                                  Icons.favorite
                                : Icons.favorite_border,
                                color: Colors.white,
                                size: 35,
                              ),
                              onPressed: () => Provider.of<Favorites>(context).toggleFavorite(restaurantId),
                            ),
                          ),
                        ],
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ]
                    ),
              ),
              _isLoading
                  ? Expanded(child:Center(
                      child: CircularProgressIndicator(),
                    ))
                  : Flexible(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 200),
                      child: _restaurant != null ?
                      FoodCategoryMenuTestFilter(
                        _restaurant != null ? _restaurant.id : null,
                      )
                          : Container(),
                    ),
                  ),
                  Flexible(
                    child: PageView(
                      controller: _tabController,
                      onPageChanged: (newPage) {
                        setState(() {
                          this.currentIndex = newPage;
                          updateCategoriesAndResetFilters(newPage);
                        });
                      },
                      children: _tabList,
                    ),
                  )
                ],)
              )])
      ),
    );
  }
}
