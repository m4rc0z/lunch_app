import 'package:flutter/material.dart';
import 'package:lunch_app/providers/restaurant.dart';
import 'package:lunch_app/widgets/weekday_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailHeader extends StatelessWidget {
  final Restaurant restaurant;
  final int currentIndex;
  final List<DateTime> weekDays;
  final void Function(int) navigateTo;

  RestaurantDetailHeader(
      this.restaurant, this.currentIndex, this.navigateTo, this.weekDays);

  _launchURL() async {
    String query = Uri.encodeComponent(this.restaurant.name + ' ' + this.restaurant.address.toString());
    var url = 'http://maps.google.com/?q=$query';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Container(
                    child: Text(
                        restaurant != null && restaurant.name != null
                            ? restaurant.name
                            : '',
                        style: TextStyle(fontSize: 30)), // TODO: use theming and fonts
                  ),
                ),
//                MaterialButton(child: const Icon(Icons.navigation), onPressed: this._launchURL,),
                WeekDayNavigationBar(this.weekDays, this.currentIndex, this.navigateTo),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
