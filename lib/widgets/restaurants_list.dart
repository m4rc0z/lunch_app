import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants.dart';
import '../screens/restaurant_detail_screen.dart';

class RestaurantsList extends StatelessWidget {
  final int currentIndex;

  RestaurantsList(this.currentIndex);

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
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Container(
                        height: 100,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: 'restaurantHero' + restaurants[i].id,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => navigateToRestaurant(context, restaurants[i].id),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(20.0),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                                  child: Image.asset( // TODO: remove this asset and load real image
                                    'assets/test.jpg',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Text(
                            restaurants[i].name != null ? restaurants[i].name : '',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ]),
        ),
      ),
    );
  }

  navigateToRestaurant(BuildContext ctx, String id) {
    Provider.of<GeneralInfo>(ctx).initMenuFoodCategoryBasedOnRestaurantFoodCategory();
    Navigator.of(ctx).push(SlideBottomRoute(page: RestaurantDetailScreen(id, currentIndex)));
  }
}

class SlideBottomRoute extends PageRouteBuilder {
  final Widget page;
  SlideBottomRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}