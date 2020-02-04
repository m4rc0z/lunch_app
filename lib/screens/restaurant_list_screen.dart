import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/widgets/detail_scaffold.dart';
import 'package:lunch_app/widgets/my_flutter_app_icons.dart';
import 'package:lunch_app/widgets/restaurant_filter.dart';
import 'package:lunch_app/widgets/title_section.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../date_util.dart';
import '../widgets/restaurants_list.dart';

class RestaurantsListScreen extends StatefulWidget {
  final void Function(int) navigateTo;
  final bool isFavourite;

  RestaurantsListScreen(this.navigateTo, this.isFavourite);

  @override
  _RestaurantsListScreenState createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen>
    with TickerProviderStateMixin {
  var _isInit = true;
  var weekdays;
  Position currentPosition;
  Geolocator geolocator = Geolocator();
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
        _scrollController.offset > (80 - kToolbarHeight);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }


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
      setState(() {
        _scrollController = ScrollController();
        _scrollController.addListener(_scrollListener);
      });
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
      body: DetailScaffold(
        hasPinnedAppBar: true,
        expandedHeight: 222.0,
        controller: _scrollController,
        slivers: <Widget>[
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: SliverAppBar(
              flexibleSpace: MediaQuery.removePadding(context: context, removeTop: true, child: Container()),
              elevation: 0.0,
              pinned: true,
              floating: true,
              title: lastStatus ? Container() : Center(child: TitleSection()),
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(200),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      weekdays != null && weekdays.length > 0
                          ? WeekDayNavigationBar(
                              weekdays,
                              Provider.of<GeneralInfo>(context)
                                  .currentWeekdayIndex,
                              widget.navigateTo)
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 18.0, top: 18.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.isFavourite
                                    ? 'FAVORITEN RESTAURANTS \nIN DEINER NÄHE'
                                    : 'RESTAURANTS \nIN DEINER NÄHE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              widget.isFavourite
                                  ? Container()
                                  : Material(
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: Colors.white,
                  child: !Provider.of<GeneralInfo>(context).isLoadingRestaurants
                      ? Container(
                          // TODO: check how to set background color globally
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: RestaurantsList(
                                    Provider.of<GeneralInfo>(context)
                                        .currentWeekdayIndex,
                                    currentPosition,
                                    widget.isFavourite),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                );
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

  void showFilter(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
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