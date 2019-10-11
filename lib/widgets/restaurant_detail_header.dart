import 'package:flutter/material.dart';
import 'package:lunch_app/providers/restaurant.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';

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
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Container(
                      child: Text(
                          restaurant != null && restaurant.name != null
                              ? restaurant.name
                              : 'Kater Hiddigeigei',
                          style: TextStyle(fontSize: 30)),
                    ),
                  ),
                  WeekDayNavigationBar(this.weekDays, this.currentIndex, this.navigateTo)
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: FoodCategoryMenuTestFilter(
                this.restaurant != null ? this.restaurant.id : null),
          ),
        ],
      ),
    );
  }
}
