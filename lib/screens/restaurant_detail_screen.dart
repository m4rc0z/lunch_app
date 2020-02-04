import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/restaurant.dart';
import 'package:lunch_app/providers/restaurants.dart';
import 'package:lunch_app/widgets/detail_scaffold.dart';
import 'package:lunch_app/widgets/favorite_button.dart';
import 'package:lunch_app/widgets/restaurant_detail_header.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ScrollController _scrollController;
  bool lastStatus = false;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  var currentIndex;

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
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
        _scrollController = ScrollController();
        _scrollController.addListener(_scrollListener);
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
    final favorite = Provider.of<Favorites>(context).getFavoriteStatus(restaurantId);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: DetailScaffold(
          hasPinnedAppBar: true,
          expandedHeight: 222.0,
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              elevation: isShrink ? 1.0 : 0.0,
              pinned: true,
              bottom: PreferredSize(                       // Add this code
                preferredSize: Size.fromHeight(10.0),      // Add this code
                child: Container(),                           // Add this code
              ),
              backgroundColor: Colors.white,
              title: AnimatedOpacity(
                opacity: isShrink ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  _restaurant.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FavoriteButton(restaurantId),
                    SizedBox(width: 10),
                  ],
                ),
              ],
              expandedHeight: 220.0,
              leading: IconButton(
                icon: new Icon(
                  Icons.close,
                  color: isShrink ? Color.fromRGBO(94, 135, 142, 1) : Colors.white,
                  size: 35,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
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
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context,
                  int index) {
                return Column(
                  children: <Widget>[
                    RestaurantDetailHeader(
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
                        !this.lastStatus
                    ),
                    Container(child:
                    (_isLoading) ? Container(child: Center(
                      child: CircularProgressIndicator(),
                    )) : Container(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
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
                                  MenusList(this.restaurantId,
                                      this.weekDays[this.currentIndex]),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                    child: Container(
                                      child: _restaurant.mapImageUrl != null
                                          ? CachedNetworkImage(
                                        imageUrl: _restaurant.mapImageUrl,
                                        placeholder: (context, url) =>
                                            Container(
                                                color: Colors.transparent,
                                                child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: CircularProgressIndicator())
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(color: Color.fromRGBO(
                                                189, 187, 173, 1)),
                                        fit: BoxFit.cover,
                                      )
                                          : Container(),
                                      alignment: Alignment.center,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Icon(Icons.location_on),),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Container(child: Text(
                                                  'TANZENPLATZ 2', style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold),),
                                                  alignment: Alignment.topLeft,),
                                                Container(child: Text(
                                                  '79713 BAD SÄCKINGEN',
                                                  style: TextStyle(fontSize: 11,
                                                      fontWeight: FontWeight
                                                          .bold),),
                                                  alignment: Alignment.topLeft,),
                                              ],
                                            ),
                                          ],
                                        ),
                                        MaterialButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(
                                                5.0),
                                          ),
                                          color: Color.fromRGBO(94, 135, 142, 1),
                                          textColor: Colors.white,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.navigation, size: 18.0,),
                                              // TODO: use different icon
                                              Text('Navigieren', style: TextStyle(
                                                  fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          onPressed: () async {
                                            String query = Uri.encodeComponent(
                                                _restaurant.name + ' ' +
                                                    _restaurant.address.toString());
                                            var url = 'http://maps.google.com/?q=$query';
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],),
                        )
                    )
                    ),
                  ],
                );
              },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

