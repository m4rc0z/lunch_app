import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_app/providers/restaurant.dart';

import 'foodCategoryMenuFilter.dart';

class RestaurantDetailHeader extends StatelessWidget {
  final Restaurant restaurant;
  final int currentIndex;
  final List<DateTime> weekDays;
  final void Function(int) navigateTo;

  RestaurantDetailHeader(
      this.restaurant, this.currentIndex, this.navigateTo, this.weekDays);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Container(
                        child: Text(restaurant != null && restaurant.name != null
                            ? restaurant.name
                            : 'Kater Hiddigeigei',
                            style: TextStyle(fontSize: 30)
                        ),
                      ),
                    ),
                    BottomNavigationBar(
                      elevation: 0.0,
                      currentIndex: this.currentIndex,
                      onTap: (newPage) {
                        this.navigateTo(newPage);
                      },
                      items: [
                        ...this.weekDays.map((weekDay) {
                          return BottomNavigationBarItem(
                            title: Container(),
                            icon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(children: <Widget>[
                                Center(
                                  child: Text(
                                    DateFormat('EEEE')
                                        .format(weekDay)
                                        .substring(0, 2),
                                    style: TextStyle(
                                        color: Color.fromRGBO(189, 187, 173, 1),
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(245, 241, 227, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(weekDay.day.toString(),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(189, 187, 173, 1),
                                            fontSize: 15),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ]),
                            ),
                            activeIcon: Column(children: <Widget>[
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    DateFormat('EEEE')
                                        .format(weekDay)
                                        .substring(0, 2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(27, 154, 170, 1),
                                  shape: BoxShape.circle,
                                ),
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: Text(weekDay.day.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ]),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
            ),
          ),
          Container(
            color: Colors.white,
            child: FoodCategoryMenuFilter(this.restaurant != null ? this.restaurant.id : null),
          ),
        ],
      ),
    );
  }
}
