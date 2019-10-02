import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants.dart';
import '../screens/restaurant_detail_screen.dart';

class RestaurantsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final restaurantsData = Provider.of<Restaurants>(context);
    final restaurants = restaurantsData.items;
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: restaurants.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: restaurants[i],
          child: Column(children: [
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 100,
                child: InkWell(
                  onTap: () => navigateToRestaurant(context, restaurants[i].id),
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: 'restaurantHero' + restaurants[i].id,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset( // TODO: remove this asset and load real image
                            'assets/test.jpg',
                            fit: BoxFit.fitWidth,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.3)]
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            )
          ]),
        ),
      ),
    );
  }

  navigateToRestaurant(BuildContext ctx, String id) {
    Navigator.of(ctx).push(CupertinoPageRoute(builder: (_) {
      return RestaurantDetailScreen(id);
    }));
  }
}
