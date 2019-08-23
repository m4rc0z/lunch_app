import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/restaurant_detail_screen.dart';
import '../providers/menus.dart';

class MenusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menusData = Provider.of<Menus>(context);
    final menus = menusData.items;
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: menus.length,
      itemBuilder: (ctx, i) =>
          ChangeNotifierProvider.value(
              value: menus[i],
              child: Column(children: [
                Container(
                width: double.infinity,
                child: Card(
                    child: Column(
                        children: <Widget>[
                          Text(menus[i].price != null ? menus[i].price : ' '),
                          Text(menus[i].courses[0].description != null ? menus[i].courses[0].description : ' '),
                        ],
                    )
                  ),
                ),
              ]),
          ),
    );
  }

  navigateToRestaurant(BuildContext ctx, String id) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return RestaurantDetailScreen(id);
    }));
  }
}
