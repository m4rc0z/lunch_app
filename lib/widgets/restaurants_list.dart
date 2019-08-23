import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants.dart';
import '../screens/restaurant_detail_screen.dart';

class RestaurantsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final restaurantsData = Provider.of<Restaurants>(context);
    final restaurants = restaurantsData.items;
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: restaurants.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: restaurants[i],
        child: Column(children: [
          Container(
              width: double.infinity,
              child: Card(
                child: Container(
                  child: InkWell(
                    onTap: () =>
                        navigateToRestaurant(context, restaurants[i].id),
                    child: Text(
                        restaurants[i].id != null ? restaurants[i].id : ' '),
                  ),
                ),
              )),
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
