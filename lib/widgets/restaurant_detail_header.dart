import 'package:flutter/material.dart';
import 'package:lunch_app/providers/restaurant.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';

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
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(242, 241, 240, 1),
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
                            : '',
                        style: TextStyle(fontSize: 30)), // TODO: use theming and fonts
                  ),
                ),
                WeekDayNavigationBar(this.weekDays, this.currentIndex, this.navigateTo)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
