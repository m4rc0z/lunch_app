import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/restaurant.dart';
import 'package:lunch_app/providers/restaurants.dart';
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
  Restaurant _restaurant;
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
    this.weekDays = DateUtil.getWeekDaysForDate(today);
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
    this.weekDays = DateUtil.getWeekDaysForDate(today);
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

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<Favorites>(context).getFavoriteStatus(restaurantId);
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
                        child: _restaurant.imageUrl != null
                            ?  Material(
                                type: MaterialType.transparency,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      imageUrl: _restaurant.imageUrl,
                                      placeholder: (context, url) => Container(
                                          color: Colors.transparent,
                                          child: FittedBox(fit: BoxFit.scaleDown, child: CircularProgressIndicator())
                                      ),
                                      errorWidget: (context, url, error) => Container(color: Color.fromRGBO(189, 187, 173, 1)),
                                      fit: BoxFit.fitWidth,
                                    )
                                  ),
                                )
                              )
                            : Container(height: 350, color: Color.fromRGBO(189, 187, 173, 1))

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
                                favorite ?
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
                  Flexible(
                    child: PageView(
                      controller: _tabController,
                      onPageChanged: (newPage) {
                        setState(() {
                          this.currentIndex = newPage;
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
