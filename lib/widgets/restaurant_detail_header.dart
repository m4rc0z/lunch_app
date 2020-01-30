import 'package:flutter/material.dart';
import 'package:lunch_app/providers/restaurant.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';

class RestaurantDetailHeader extends StatelessWidget {
  final Restaurant restaurant;
  final int currentIndex;
  final List<DateTime> weekDays;
  final void Function(int) navigateTo;
  final bool unCollapsed;

  RestaurantDetailHeader(this.restaurant, this.currentIndex, this.navigateTo,
      this.weekDays, this.unCollapsed);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0, left: 20.0, top: 25.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              child: AnimatedOpacity(
                                opacity: unCollapsed ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 300),
                                child: Text(
                                    restaurant != null &&
                                            restaurant.name != null
                                        ? restaurant.name.toUpperCase()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 30,
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Icon(Icons.access_time),
                              ),
                              Container(
                                child: Text('KÜCHENÖFFNUNGSZEITEN MITTAGS',
                                    style: TextStyle(
                                        fontSize:
                                            12.0)), // TODO: use theming and fonts
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, top: 2.0),
                            child: Container(
                              child: Text(
                                  restaurant != null &&
                                          restaurant.openingTimesLine1 != null
                                      ? restaurant.openingTimesLine1
                                          .toUpperCase()
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          11.0)), // TODO: use theming and fonts
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, top: 2.0),
                            child: Container(
                              child: Text(
                                  restaurant != null &&
                                          restaurant.openingTimesLine2 != null
                                      ? restaurant.openingTimesLine2
                                          .toUpperCase()
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          11.0)), // TODO: use theming and fonts
                            ),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        opacity: unCollapsed ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Color.fromRGBO(94, 135, 142, 1),
                              size: 30.0,
                            ),
                            Text(
                              restaurant != null && restaurant.distance != null
                                  ? (restaurant.distance / 1000.00)
                                          .toStringAsFixed(1) +
                                      ' KM'
                                  : '',
                              style: TextStyle(
                                  color: Color.fromRGBO(94, 135, 142, 1),
                                  fontSize: 11.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
//                MaterialButton(child: const Icon(Icons.navigation), onPressed: this._launchURL,),
                WeekDayNavigationBar(
                    this.weekDays, this.currentIndex, this.navigateTo),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
