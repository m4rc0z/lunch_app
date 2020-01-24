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
              Provider.of<GeneralInfo>(context).weekDays[0],
              Provider.of<GeneralInfo>(context).weekDays[6])
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
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    var fadeAnimation = Tween(
        begin: 1.0,
        end: 1.0
    ).animate(controller);

    final favorite = Provider.of<Favorites>(context).getFavoriteStatus(restaurantId);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
            children: <Widget>[
              Container(
                height: 375,
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
                                    child: _restaurant.imageUrl != null
                                        ? CachedNetworkImage(
                                      imageUrl: _restaurant.imageUrl,
                                      placeholder: (context, url) => Container(
                                          color: Colors.transparent,
                                          child: FittedBox(fit: BoxFit.scaleDown, child: CircularProgressIndicator())
                                      ),
                                      errorWidget: (context, url, error) => Container(color: Color.fromRGBO(189, 187, 173, 1)),
                                      fit: BoxFit.fitWidth,
                                    )
                                        : Container()
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
                              setState(() {
                                this.currentIndex = newPage;
                              });
                                  // TODO: fetch and set categories for menuCategories -> add new function
//                          this._tabController.jumpToPage(newPage);
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
                  : Flexible(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            child: Text(
                              'MITTAGSMENÜS',
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
//                        AnimatedSize(
//                          vsync: this,
//                          curve: Curves.easeInOut,
//                          duration: Duration(milliseconds: 300),
//                            child: FadeTransition(
//                              opacity: fadeAnimation,
//                                child: MenusList(this.restaurantId, this.weekDays[this.currentIndex]),
//                            )
//                        )
                        MenusList(this.restaurantId, this.weekDays[this.currentIndex]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            child: Text(
                                'WEGBESCHREIBUNG',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                          child: Container(
                            child: _restaurant.mapImageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: _restaurant.mapImageUrl,
                                placeholder: (context, url) => Container(
                                    color: Colors.transparent,
                                    child: FittedBox(fit: BoxFit.scaleDown, child: CircularProgressIndicator())
                                ),
                                errorWidget: (context, url, error) => Container(color: Color.fromRGBO(189, 187, 173, 1)),
                                fit: BoxFit.cover,
                              )
                             : Container(),
                            alignment: Alignment.center,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(child: Icon(Icons.location_on),),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(child: Text('TANZENPLATZ 2', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),), alignment: Alignment.topLeft,),
                                      Container(child: Text('79713 BAD SÄCKINGEN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),), alignment: Alignment.topLeft,),
                                    ],
                                  ),
                                ],
                              ),
                              MaterialButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                color: Color.fromRGBO(94, 135, 142, 1),
                                textColor: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.navigation, size: 18.0,), // TODO: use different icon
                                    Text('Navigieren'),
                                  ],
                                ),
                                onPressed: () => print('navigate'),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ],),
                  )
              )])
      ),
    );
  }
}
